// Run inside electerm 5.7.5 DevTools Console. Uses the app's normal persistence.
// Repeatable; the first backup is retained. Restore: await electermEverforest.restore()
(async () => {
  "use strict";
  const store = window.store;
  if (!store?.configLoaded || !Array.isArray(store.terminalThemes)) {
    throw new Error("Wait for electerm to finish loading before applying this preset.");
  }
  const required = ["updateConfig", "setTheme", "addItem", "editItem", "delItem", "setLeftSidePanelWidth"];
  for (const name of required) {
    if (typeof store[name] !== "function") throw new Error(`Unsupported electerm API: ${name}`);
  }
  const theme = {
  "id": "nixos-everforest",
  "name": "NixOS Everforest",
  "themeConfig": {
    "background": "#2d353b",
    "foreground": "#d3c6aa",
    "cursor": "#a7c080",
    "cursorAccent": "#2d353b",
    "selectionBackground": "#475258",
    "black": "#343f44",
    "red": "#e67e80",
    "green": "#a7c080",
    "yellow": "#dbbc7f",
    "blue": "#7fbbb3",
    "magenta": "#d699b6",
    "cyan": "#83c092",
    "white": "#d3c6aa",
    "brightBlack": "#859289",
    "brightRed": "#e67e80",
    "brightGreen": "#a7c080",
    "brightYellow": "#dbbc7f",
    "brightBlue": "#7fbbb3",
    "brightMagenta": "#d699b6",
    "brightCyan": "#83c092",
    "brightWhite": "#fdf6e3"
  },
  "uiThemeConfig": {
    "main": "#2d353b",
    "main-dark": "#272e33",
    "main-light": "#343f44",
    "text": "#d3c6aa",
    "text-light": "#e6e2cc",
    "text-dark": "#9da9a0",
    "text-disabled": "#859289",
    "primary": "#a7c080",
    "info": "#7fbbb3",
    "success": "#83c092",
    "error": "#e67e80",
    "warn": "#dbbc7f"
  }
};
  const backupKey = "nixos-everforest-backup-v1";
  const bookmarkId = "nixos-local-fish";
  const clone = value => JSON.parse(JSON.stringify(value));
  const patch = {
    theme: theme.id,
    execMac: "/Users/fy/.nix-profile/bin/fish",
    // electerm adds --login itself on macOS.
    execMacArgs: [],
    fontFamily: "JetBrainsMono Nerd Font, JetBrains Mono, Menlo, monospace",
    fontSize: 15,
    scrollback: 10000,
    cursorStyle: "block",
    cursorBlink: false,
    opacity: 1,
    sshSftpSplitView: false,
    disableShortcutBar: true,
    onlyShowTitleInTab: true,
    switchTabOnHover: false,
    remoteMonitorBarEnabled: false,
    leftSideBarIcons: ["bookmarks", "quickConnect", "terminalThemes", "setting", "settingSync", "widgets"]
  };
  const originalConfig = Object.fromEntries(Object.keys(patch).map(key => [key, store.config[key]]));
  const originalTheme = store.terminalThemes.find(item => item.id === theme.id);
  const originalBookmark = store.bookmarks.find(item => item.id === bookmarkId);
  const group = store.bookmarkGroups.find(item => item.id === "default");
  // Save only changed preferences and our own entries, never SSH credentials.
  if (!localStorage.getItem(backupKey)) {
    localStorage.setItem(backupKey, JSON.stringify({
      config: originalConfig,
      theme: originalTheme ? clone(originalTheme) : null,
      bookmark: originalBookmark ? clone(originalBookmark) : null,
      groupHadBookmark: !!group?.bookmarkIds?.includes(bookmarkId),
      sidebarWidth: store._leftSidePanelWidth
    }));
  }
  function upsert(table, item) {
    if (store[table].some(existing => existing.id === item.id)) store.editItem(item.id, item, table);
    else store.addItem(item, table);
  }
  upsert("terminalThemes", theme);
  upsert("bookmarks", {
    id: bookmarkId,
    title: "macOS · fish",
    type: "local",
    execMac: patch.execMac,
    execMacArgs: [],
    color: "#a7c080",
    description: "Nix fish login shell"
  });
  if (group && !group.bookmarkIds?.includes(bookmarkId)) {
    store.editItem(group.id, {bookmarkIds: [bookmarkId, ...(group.bookmarkIds || [])]}, "bookmarkGroups");
  }
  store.updateConfig(patch);
  store.setTheme(theme.id);
  store.setLeftSidePanelWidth(260);
  window.electermEverforest = {
    async restore() {
      const saved = JSON.parse(localStorage.getItem(backupKey) || "null");
      if (!saved) throw new Error("No Everforest backup found.");
      store.updateConfig(saved.config);
      if (saved.config.theme) store.setTheme(saved.config.theme);
      if (saved.theme) upsert("terminalThemes", saved.theme);
      else store.delItem({id: theme.id}, "terminalThemes");
      if (saved.bookmark) upsert("bookmarks", saved.bookmark);
      else store.delItem({id: bookmarkId}, "bookmarks");
      const currentGroup = store.bookmarkGroups.find(item => item.id === "default");
      if (currentGroup && !saved.groupHadBookmark) {
        store.editItem(currentGroup.id, {
          bookmarkIds: (currentGroup.bookmarkIds || []).filter(id => id !== bookmarkId)
        }, "bookmarkGroups");
      }
      store.setLeftSidePanelWidth(saved.sidebarWidth);
      // Let the application's debounced config/database watchers flush.
      await new Promise(resolve => setTimeout(resolve, 2500));
      localStorage.removeItem(backupKey);
      console.info("Previous electerm preferences restored.");
    }
  };
  await new Promise(resolve => setTimeout(resolve, 2500));
  console.info("Everforest applied. Open a NEW local tab or the macOS · fish bookmark. Restore: await electermEverforest.restore()");
})();
