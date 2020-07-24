/* eslint-disable @typescript-eslint/no-triple-slash-reference */
/// <reference path="node_modules/phoenix-typings/index.d.ts" />
/// <reference types="lodash" />

/**
 * TODO:
 *
 * - switch to nearest window of an app on current display
 * - `switchApp` should maximize app if it's minimized
 * - toggle displays
 * - move window to second screen
 * - prompt like split with e.g. split editor with safari
 */

Phoenix.set({ openAtLogin: true });

/* eslint-disable-next-line @typescript-eslint/no-explicit-any */
const stringify = (value: any): string => {
  switch (typeof value) {
    case 'object':
      return JSON.stringify(value, null, 2);
    case 'function':
      return value.toString();
    default:
      return value;
  }
};

/** Pretty log to Console.app */
/* eslint-disable-next-line @typescript-eslint/no-unused-vars, @typescript-eslint/no-explicit-any */
const log = (...args: any[]): void => {
  args = args.map(arg => stringify(arg));
  Phoenix.log(args.join(' '));
};

// Hyper
const Hyper: Phoenix.ModifierKey[] = ['ctrl', 'shift', 'alt', 'cmd'];

const mapHyperKeys = (map: { [index: string]: () => void }) =>
  Object.keys(map).forEach(key => Key.on(key, Hyper, map[key]));

/** Launch of focus on already launched app */
const switchApp = (app: string) => () => {
  const launched = App.launch(app);
  if (launched) launched.focus();
};

/** Switch to the list of apps. Rightmost app has the highest priority */
const switchApps = (...apps: string[]) => () => {
  if (apps.length === 1) {
    switchApp(_.head(apps) || '')();
  } else {
    const app = _.head(
      [...apps]
        .reverse()
        .map(App.get)
        .filter(_.negate(_.isNil)),
    );

    app ? app.focus() : switchApp(_.head(apps) || '')();
  }
};

const withFocused = (fn: (w: Window) => void) => {
  const focused = Window.focused();
  if (focused) fn(focused);
};

const only = () =>
  withFocused(current => {
    _.flatMap(current.spaces(), s => s.windows())
      .filter(window => !window.isEqual(current))
      .forEach(window => window.minimize());
  });

const center = () =>
  withFocused(window => {
    const screen = window.screen().flippedVisibleFrame();
    const { width, height } = window.frame();

    window.setTopLeft({
      x: screen.x + screen.width / 2 - width / 2,
      y: screen.y + screen.height / 2 - height / 2,
    });
  });

/** Resize current window */
const resize = (getRect: (currentScreen: Rectangle) => Partial<Rectangle>) => {
  const window = Window.focused();

  if (window) {
    window.setFrame({
      ...window.screen().flippedVisibleFrame(),
      ...getRect(window.screen().flippedVisibleFrame()),
    });
  }
};

const leftHalf = () =>
  resize(({ width }) => ({
    width: width / 2,
  }));

const rightHalf = () =>
  resize(({ x, width }) => ({
    x: width - width / 2 + x,
    width: width / 2,
  }));

const leftThreeFourths = () =>
  resize(({ width }) => ({
    width: width * 0.75,
  }));

const rightThreeFourths = () =>
  resize(({ width, x }) => ({
    x: width - width * 0.75 + x,
    width: width * 0.75,
  }));

const perfectEditor = () =>
  resize(({ width, x }) => ({
    x: width - width * 0.6 + x,
    width: width * 0.6,
  }));

const DisplayPresets = {
  Left: [
    'id:2A598ACF-DADC-00E5-F48F-6624E6A9A951 res:1792x1120 hz:59 color_depth:8 scaling:on origin:(0,0) degree:0',
    'id:41AB4FC6-4993-396B-A30E-657DD8D2DE03 res:2560x1440 hz:60 color_depth:8 scaling:on origin:(1792,-920) degree:0',
  ],
  Right: [
    'id:2A598ACF-DADC-00E5-F48F-6624E6A9A951 res:1792x1120 hz:59 color_depth:8 scaling:on origin:(0,0) degree:0',
    'id:41AB4FC6-4993-396B-A30E-657DD8D2DE03 res:2560x1440 hz:60 color_depth:8 scaling:on origin:(-2560,-915) degree:0',
  ],
  Below: [
    'id:2A598ACF-DADC-00E5-F48F-6624E6A9A951 res:1792x1120 hz:59 color_depth:8 scaling:on origin:(0,0) degree:0',
    'id:41AB4FC6-4993-396B-A30E-657DD8D2DE03 res:2560x1440 hz:60 color_depth:8 scaling:on origin:(-392,-1440) degree:0',
  ],
  Mirror: [
    'id:41AB4FC6-4993-396B-A30E-657DD8D2DE03+2A598ACF-DADC-00E5-F48F-6624E6A9A951 res:2560x1440 hz:60 color_depth:8 scaling:on origin:(0,0) degree:0',
  ],
};

const displayplacerPath = '/usr/local/bin/displayplacer';

const arrangeDisplays = (args: string[], msg: string) => () => {
  Task.run(displayplacerPath, args, () => {
    Modal.build({
      duration: 3.4,
      text: msg,
      weight: 48,
      origin: () => ({ x: 100, y: 100 }),
    }).show();
  });
};

const keys = {
  s: ['Safari'],
  g: ['Google Chrome', 'Chromium'],
  i: ['iTerm', 'iTerm2', 'Hyper'],
  z: ['Slack'],
  n: ['Notion'],
  e: ['Code', 'Visual Studio Code', 'VimR', 'Emacs', 'Oni'],
  r: ['Roam'],
  m: ['Mail'],
  v: ['Sketch'],
  t: ['Telegram'],
};

mapHyperKeys({
  ..._.mapValues(keys, val => switchApps(...val)),
  c: center,
  o: only,
  '[': leftThreeFourths,
  ']': rightThreeFourths,
  9: leftHalf,
  0: rightHalf,
  '=': perfectEditor,
  1: arrangeDisplays(DisplayPresets.Left, 'MacBook is on the left'),
  2: arrangeDisplays(DisplayPresets.Below, 'MacBook is below'),
  3: arrangeDisplays(DisplayPresets.Right, 'MacBook is on the right'),
  4: arrangeDisplays(DisplayPresets.Mirror, 'Displays are mirrored'),
  '\\': () => {
    Modal.build({
      duration: 5,
      text: _.toPairs(keys)
        .map(([k, v]) => `${k}: ${v.join(', ')}`)
        .join('\n'),
      weight: 30,
      origin: () => ({ x: 200, y: 200 }),
    }).show();
  },
});
