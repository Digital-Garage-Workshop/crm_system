import { computed } from 'vue';

<<<<<<< HEAD
export function useKbd(keys) {
  const keySymbols = {
    $mod: navigator.platform.includes('Mac') ? '⌘' : 'Ctrl',
=======
function isMacOS() {
  // Check modern userAgentData API first
  if (navigator.userAgentData?.platform) {
    return navigator.userAgentData.platform === 'macOS';
  }
  // Fallback to navigator.platform
  return (
    navigator.platform.startsWith('Mac') || navigator.platform === 'iPhone'
  );
}

export function useKbd(keys) {
  const keySymbols = {
    $mod: isMacOS() ? '⌘' : 'Ctrl',
>>>>>>> upstream/develop
    shift: '⇧',
    alt: '⌥',
    ctrl: 'Ctrl',
    cmd: '⌘',
    option: '⌥',
<<<<<<< HEAD
    enter: '↩',
=======
    enter: '↵',
>>>>>>> upstream/develop
    tab: '⇥',
    esc: '⎋',
  };

  return computed(() => {
    return keys
      .map(key => keySymbols[key.toLowerCase()] || key)
<<<<<<< HEAD
      .join('')
      .toUpperCase();
  });
}
=======
      .join(' ')
      .toUpperCase();
  });
}

export function getModifierKey() {
  return isMacOS() ? '⌘' : 'Ctrl';
}
>>>>>>> upstream/develop
