-- Copy a GitHub permalink to the current line or visual selection.
-- Links are pinned to a commit that exists on the remote, so they resolve when opened.
local M = {}

-- Files GitHub renders by default; ?plain=1 makes line anchors work for them
local rendered = { md = true, markdown = true, mdx = true, rst = true, adoc = true, asciidoc = true, org = true, ipynb = true }

local function git(dir, ...)
	local res = vim.system({ "git", "-C", dir, ... }, { text = true }):wait()
	return res.code == 0 and vim.trim(res.stdout) or nil, res.code
end

local function fail(msg)
	vim.notify("gitlink: " .. msg, vim.log.levels.ERROR)
end

-- Resolve SSH host aliases from ~/.ssh/config (e.g. "github-work" -> "github.com")
local function ssh_hostname(alias)
	local res = vim.system({ "ssh", "-G", alias }, { text = true }):wait()
	local host = res.code == 0 and ("\n" .. res.stdout):match("\nhostname%s+(%S+)") or alias
	return host == "ssh.github.com" and "github.com" or host
end

-- git@host:owner/repo.git, ssh://git@host:22/owner/repo.git, https://host/owner/repo.git
local function repo_url(remote_url)
	local scheme = remote_url:match("^(%a[%w+.-]*)://")
	local host, path
	if scheme then
		local rest = remote_url:gsub("^%a[%w+.-]*://", ""):gsub("^[^@/]*@", "")
		host, path = rest:match("^([^/:]+)[^/]*/(.+)$")
	else
		host, path = remote_url:gsub("^[^@/]*@", ""):match("^([^/:]+):(.+)$")
	end
	if not host then return nil end
	if scheme ~= "https" and scheme ~= "http" then host = ssh_hostname(host) end
	path = path:gsub("/+$", ""):gsub("%.git$", "")
	return ("https://%s/%s"):format(host, path)
end

local function urlencode(s)
	return (s:gsub("[^%w%-._~/]", function(c) return ("%%%02X"):format(c:byte()) end))
end

-- HEAD if it's on the remote, otherwise the newest ancestor that is
local function remote_commit(dir, remote, upstream)
	local head = git(dir, "rev-parse", "HEAD")
	if not head then return nil end
	if (git(dir, "branch", "-r", "--list", remote .. "/*", "--contains", head) or "") ~= "" then
		return head
	end
	return (upstream and git(dir, "merge-base", head, upstream)) or git(dir, "merge-base", head, remote .. "/HEAD")
end

function M.copy()
	local line1, line2 = vim.fn.line("."), vim.fn.line(".")
	if vim.fn.mode():match("^[vV\22]") then
		line1 = vim.fn.line("v")
		vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
	end
	if line1 > line2 then line1, line2 = line2, line1 end

	local file = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(0))
	if not file or vim.bo.buftype ~= "" then return fail("buffer is not a file") end
	local dir, name = vim.fs.dirname(file), vim.fs.basename(file)

	local prefix = git(dir, "rev-parse", "--show-prefix")
	if not prefix then return fail("not in a git repository") end

	local branch = git(dir, "symbolic-ref", "--short", "-q", "HEAD")
	local remote = branch and git(dir, "config", "branch." .. branch .. ".remote")
	local upstream = branch and git(dir, "rev-parse", "--abbrev-ref", branch .. "@{upstream}")
	local remotes = vim.split(git(dir, "remote") or "", "\n", { trimempty = true })
	if not vim.list_contains(remotes, remote) then
		remote = vim.list_contains(remotes, "origin") and "origin" or remotes[1]
		upstream = nil
	end
	if not remote then return fail("repository has no remotes") end

	local base_url = repo_url(git(dir, "remote", "get-url", remote) or "")
	if not base_url then return fail("can't resolve URL of remote " .. remote) end

	local commit = remote_commit(dir, remote, upstream)
	if not commit then return fail("no commit of HEAD is on " .. remote .. ", push first") end

	local path = prefix .. name
	if not git(dir, "cat-file", "-e", commit .. ":" .. path) then
		return fail(path .. " is not on " .. remote .. " yet, push first")
	end

	local url = ("%s/blob/%s/%s"):format(base_url, commit, urlencode(path))
	if rendered[(name:match("%.(%w+)$") or ""):lower()] then url = url .. "?plain=1" end
	url = url .. (line1 == line2 and ("#L%d"):format(line1) or ("#L%d-L%d"):format(line1, line2))

	vim.fn.setreg("+", url)

	local _, changed = git(dir, "diff", "--quiet", commit, "--", name)
	if vim.bo.modified or changed ~= 0 then
		vim.notify(("Copied %s\n%s differs from %s on %s, lines may be off"):format(url, path, commit:sub(1, 7), remote),
			vim.log.levels.WARN)
	else
		vim.notify("Copied " .. url)
	end
end

return M
