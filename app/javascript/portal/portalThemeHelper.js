import { adjustColorForContrast } from '../shared/helpers/colorHelper.js';

<<<<<<< HEAD
export const setPortalHoverColor = theme => {
  // This function is to set the hover color for the portal
  if (theme === 'system') {
    const prefersDarkMode = window.matchMedia(
      '(prefers-color-scheme: dark)'
    ).matches;
    theme = prefersDarkMode ? 'dark' : 'light';
  }

  const portalColor = window.portalConfig.portalColor;
  const bgColor = theme === 'dark' ? '#151718' : 'white';
=======
const getResolvedTheme = theme => {
  // Helper to get resolved theme (handles 'system' -> 'dark'/'light')
  if (theme === 'system') {
    return window.matchMedia('(prefers-color-scheme: dark)').matches
      ? 'dark'
      : 'light';
  }
  return theme;
};

export const setPortalHoverColor = theme => {
  // This function is to set the hover color for the portal
  const resolvedTheme = getResolvedTheme(theme);
  const portalColor = window.portalConfig.portalColor;
  const bgColor = resolvedTheme === 'dark' ? '#151718' : 'white';
>>>>>>> upstream/develop
  const hoverColor = adjustColorForContrast(portalColor, bgColor);

  // Set hover color for border and text dynamically
  document.documentElement.style.setProperty(
    '--dynamic-hover-color',
    hoverColor
  );
};

export const removeQueryParamsFromUrl = (queryParam = 'theme') => {
  // This function is to remove the theme query param from the URL
  // This is done so that the theme is not persisted in the URL
  // This is called when the theme is switched from the dropdown
  const url = new URL(window.location.href);
  const param = url.searchParams.get(queryParam);

  if (param) {
    url.searchParams.delete(queryParam);
    window.history.replaceState({}, '', url.toString()); // Convert URL to string
  }
};

export const updateThemeInHeader = theme => {
  // This function is to update the theme selection in the header in real time
  const themeToggleButton = document.getElementById('toggle-appearance');
<<<<<<< HEAD

  if (!themeToggleButton) return;
  const allElementInButton =
    themeToggleButton.querySelectorAll('.theme-button');

  if (!allElementInButton) return;
  allElementInButton.forEach(button => {
    button.classList.toggle('hidden', button.dataset.theme !== theme);
    button.classList.toggle('flex', button.dataset.theme === theme);
=======
  if (!themeToggleButton) return;

  const allThemeButtons = themeToggleButton.querySelectorAll('.theme-button');
  if (!allThemeButtons.length) return;

  allThemeButtons.forEach(button => {
    const isActive = button.dataset.theme === theme;
    button.classList.toggle('hidden', !isActive);
    button.classList.toggle('flex', isActive);
>>>>>>> upstream/develop
  });
};

export const switchTheme = theme => {
<<<<<<< HEAD
  if (theme === 'system') {
    localStorage.removeItem('theme');
    const prefersDarkMode = window.matchMedia(
      '(prefers-color-scheme: dark)'
    ).matches;
    // remove this so that the system theme is used

    document.documentElement.classList.remove('dark', 'light');
    document.documentElement.classList.add(prefersDarkMode ? 'dark' : 'light');
  } else {
    localStorage.theme = theme;

    document.documentElement.classList.remove('dark', 'light');
    document.documentElement.classList.add(theme);
  }

  setPortalHoverColor(theme);
  updateThemeInHeader(theme);
  removeQueryParamsFromUrl();
};

export const initializeThemeSwitchButtons = () => {
  const appearanceDropdown = document.getElementById('appearance-dropdown');
  appearanceDropdown.dataset.currentTheme = localStorage.theme || 'system';

  appearanceDropdown.addEventListener('click', event => {
    const target = event.target.closest('button[data-theme]');

    if (target) {
      const { theme } = target.dataset;
      // setting this data property will automatically toggle the checkmark using CSS
      appearanceDropdown.dataset.currentTheme = theme;
      switchTheme(theme);
      // wait for a bit before hiding the dropdown
      appearanceDropdown.style.display = 'none';
    }
  });
};

export const initializeToggleButton = () => {
  const themeToggleButton = document.getElementById('toggle-appearance');

  themeToggleButton?.addEventListener('click', () => {
    const appearanceDropdown = document.getElementById('appearance-dropdown');

    const isCurrentlyHidden = appearanceDropdown.style.display === 'none';
    // Toggle the appearanceDropdown
    appearanceDropdown.style.display = isCurrentlyHidden ? 'flex' : 'none';
=======
  // Update localStorage
  if (theme === 'system') {
    localStorage.removeItem('theme');
  } else {
    localStorage.theme = theme;
  }

  const resolvedTheme = getResolvedTheme(theme);
  document.documentElement.classList.remove('dark', 'light');
  document.documentElement.classList.add(resolvedTheme);

  setPortalHoverColor(theme);
  updateThemeInHeader(theme);
  removeQueryParamsFromUrl();
  // Update both dropdown data attributes
  document.querySelectorAll('.appearance-menu').forEach(menu => {
    menu.dataset.currentTheme = theme;
  });
};

export const initializeThemeHandlers = () => {
  const toggle = document.getElementById('toggle-appearance');
  const dropdown = document.getElementById('appearance-dropdown');
  if (!toggle || !dropdown) return;

  // Toggle appearance dropdown
  toggle.addEventListener('click', e => {
    e.stopPropagation();
    dropdown.dataset.dropdownOpen = String(
      dropdown.dataset.dropdownOpen !== 'true'
    );
  });

  document.addEventListener('click', ({ target }) => {
    if (toggle.contains(target)) return;

    const themeBtn = target.closest('.appearance-menu button[data-theme]');
    const menu = themeBtn?.closest('.appearance-menu');

    if (themeBtn && menu) {
      switchTheme(themeBtn.dataset.theme);
      menu.dataset.dropdownOpen = 'false';

      if (menu.id === 'mobile-appearance-dropdown') {
        // Set the mobile menu toggle to false after a delay to ensure the transition is completed
        setTimeout(() => {
          const mobileToggle = document.getElementById('mobile-menu-toggle');
          if (mobileToggle) mobileToggle.checked = false;
        }, 300);
      }

      return;
    }

    // Close the desktop appearance dropdown if clicked outside
    if (
      dropdown.dataset.dropdownOpen === 'true' &&
      !dropdown.contains(target)
    ) {
      dropdown.dataset.dropdownOpen = 'false';
    }
>>>>>>> upstream/develop
  });
};

export const initializeMediaQueryListener = () => {
  const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');

  mediaQuery.addEventListener('change', () => {
    if (['light', 'dark'].includes(localStorage.theme)) return;

    switchTheme('system');
  });
};

export const initializeTheme = () => {
  if (window.portalConfig.isPlainLayoutEnabled === 'true') return;
  // start with updating the theme in the header, this will set the current theme on the button
  // and set the hover color at the start of init, this is set again when the theme is switched
<<<<<<< HEAD
  setPortalHoverColor(localStorage.theme || 'system');
  window.updateThemeInHeader = updateThemeInHeader;
  updateThemeInHeader(localStorage.theme || 'system');

  // add the event listeners for the dropdown toggle and theme buttons
  initializeToggleButton();
  initializeThemeSwitchButtons();
=======
  switchTheme(localStorage.theme || 'system');

  window.updateThemeInHeader = updateThemeInHeader;

  // add the event listeners for the dropdown toggle and theme buttons
  initializeThemeHandlers();
>>>>>>> upstream/develop

  // add the media query listener to update the theme when the system theme changes
  initializeMediaQueryListener();
};
