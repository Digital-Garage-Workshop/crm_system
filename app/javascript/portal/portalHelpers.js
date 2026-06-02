import { createApp } from 'vue';
import VueDOMPurifyHTML from 'vue-dompurify-html';
import { domPurifyConfig } from '../shared/helpers/HTMLSanitizer';
import { directive as onClickaway } from 'vue3-click-away';
<<<<<<< HEAD
=======
import { isSameHost } from '@chatwoot/utils';
>>>>>>> upstream/develop

import slugifyWithCounter from '@sindresorhus/slugify';
import PublicArticleSearch from './components/PublicArticleSearch.vue';
import TableOfContents from './components/TableOfContents.vue';
<<<<<<< HEAD
import { initializeTheme } from './portalThemeHelper.js';
=======
import SidebarThemeToggle from './components/SidebarThemeToggle.vue';
import { initializeTheme } from './portalThemeHelper.js';
import { getLanguageDirection } from 'dashboard/components/widgets/conversation/advancedFilterItems/languages.js';
>>>>>>> upstream/develop

export const getHeadingsfromTheArticle = () => {
  const rows = [];
  const articleElement = document.getElementById('cw-article-content');
  articleElement.querySelectorAll('h1, h2, h3').forEach(element => {
<<<<<<< HEAD
    const slug = slugifyWithCounter(element.innerText);
    element.id = slug;
    element.className = 'scroll-mt-24 heading';
    element.innerHTML += `<a class="permalink text-slate-600 ml-3" href="#${slug}" title="${element.innerText}" data-turbolinks="false">#</a>`;
    rows.push({
      slug,
      title: element.innerText,
=======
    const headingText = element.innerText;
    const slug = slugifyWithCounter(headingText);
    element.id = slug;
    element.className = 'scroll-mt-24 heading';

    const permalink = document.createElement('a');
    permalink.className = 'permalink text-slate-600 ml-3';
    permalink.href = `#${slug}`;
    permalink.title = headingText;
    permalink.dataset.turbolinks = 'false';
    permalink.textContent = '#';
    element.appendChild(permalink);

    rows.push({
      slug,
      title: headingText,
>>>>>>> upstream/develop
      tag: element.tagName.toLowerCase(),
    });
  });
  return rows;
};

export const openExternalLinksInNewTab = () => {
  const { customDomain, hostURL } = window.portalConfig;
<<<<<<< HEAD
  const isSameHost =
    window.location.href.includes(customDomain) ||
    window.location.href.includes(hostURL);

  // Modify external links only on articles page
  const isOnArticlePage =
    isSameHost && document.querySelector('#cw-article-content') !== null;
=======
  const isOnArticlePage =
    document.querySelector('#cw-article-content') !== null;
>>>>>>> upstream/develop

  document.addEventListener('click', event => {
    if (!isOnArticlePage) return;

<<<<<<< HEAD
    // Some of the links come wrapped in strong tag through prosemirror

    const isTagAnchor = event.target.tagName === 'A';
    const isParentTagAnchor =
      event.target.tagName === 'STRONG' &&
      event.target.parentNode.tagName === 'A';

    if (isTagAnchor || isParentTagAnchor) {
      const link = isTagAnchor ? event.target : event.target.parentNode;

      const isInternalLink =
        link.hostname === window.location.hostname ||
        link.href.includes(customDomain) ||
        link.href.includes(hostURL);
=======
    const link = event.target.closest('a');

    if (link) {
      const currentLocation = window.location.href;
      const linkHref = link.href;

      // Check against current location and custom domains
      const isInternalLink =
        isSameHost(linkHref, currentLocation) ||
        (customDomain && isSameHost(linkHref, customDomain)) ||
        (hostURL && isSameHost(linkHref, hostURL));
>>>>>>> upstream/develop

      if (!isInternalLink) {
        link.target = '_blank';
        link.rel = 'noopener noreferrer'; // Security and performance benefits
        // Prevent default if you want to stop the link from opening in the current tab
        event.stopPropagation();
      }
    }
  });
};

export const InitializationHelpers = {
  navigateToLocalePage: () => {
<<<<<<< HEAD
    const allLocaleSwitcher = document.querySelector('.locale-switcher');

    if (!allLocaleSwitcher) {
      return false;
    }

    const { portalSlug } = allLocaleSwitcher.dataset;
    allLocaleSwitcher.addEventListener('change', event => {
      window.location = `/hc/${portalSlug}/${event.target.value}/`;
    });
    return false;
  },

  initializeSearch: () => {
    const isSearchContainerAvailable = document.querySelector('#search-wrap');
    if (isSearchContainerAvailable) {
      // eslint-disable-next-line vue/one-component-per-file
      const app = createApp({
        components: { PublicArticleSearch },
        template: '<PublicArticleSearch />',
      });

      app.use(VueDOMPurifyHTML, domPurifyConfig);
      app.directive('on-clickaway', onClickaway);
      app.mount('#search-wrap');
    }
=======
    document.addEventListener('change', e => {
      const localeSwitcher = e.target.closest('.locale-switcher');
      if (!localeSwitcher) return;

      const { portalSlug } = localeSwitcher.dataset;
      window.location.href = `/hc/${encodeURIComponent(portalSlug)}/${encodeURIComponent(localeSwitcher.value)}/`;
    });
  },

  initializeSearch: () => {
    ['#search-wrap', '#search-wrap-hero'].forEach(selector => {
      const mountPoint = document.querySelector(selector);
      if (!mountPoint) return;
      const size = mountPoint.dataset.size || 'default';
      const showKbd = !!mountPoint.dataset.kbd;
      // eslint-disable-next-line vue/one-component-per-file
      const app = createApp({
        components: { PublicArticleSearch },
        data() {
          return { size, showKbd };
        },
        template: '<PublicArticleSearch :size="size" :show-kbd="showKbd" />',
      });
      app.use(VueDOMPurifyHTML, domPurifyConfig);
      app.directive('on-clickaway', onClickaway);
      app.mount(selector);
    });
>>>>>>> upstream/develop
  },

  initializeTableOfContents: () => {
    const isOnArticlePage = document.querySelector('#cw-hc-toc');
    if (isOnArticlePage) {
      // eslint-disable-next-line vue/one-component-per-file
      const app = createApp({
        components: { TableOfContents },
        data() {
          return { rows: getHeadingsfromTheArticle() };
        },
        template: '<table-of-contents :rows="rows" />',
      });

      app.use(VueDOMPurifyHTML, domPurifyConfig);
      app.mount('#cw-hc-toc');
    }
  },

<<<<<<< HEAD
=======
  initializeSidebarThemeToggle: () => {
    const mountPoint = document.querySelector('#sidebar-theme-toggle');
    if (mountPoint) {
      // eslint-disable-next-line vue/one-component-per-file
      const app = createApp({
        components: { SidebarThemeToggle },
        template: '<sidebar-theme-toggle />',
      });
      app.directive('on-clickaway', onClickaway);
      app.mount('#sidebar-theme-toggle');
    }
  },

  initializeDetailsClickAway: () => {
    document.addEventListener('click', event => {
      document
        .querySelectorAll('details[data-close-on-clickaway][open]')
        .forEach(details => {
          if (!details.contains(event.target)) {
            details.removeAttribute('open');
          }
        });
    });
  },

>>>>>>> upstream/develop
  appendPlainParamToURLs: () => {
    [...document.getElementsByTagName('a')].forEach(aTagElement => {
      if (aTagElement.href && aTagElement.href.includes('/hc/')) {
        const url = new URL(aTagElement.href);
        url.searchParams.set('show_plain_layout', 'true');

        aTagElement.setAttribute('href', url);
      }
    });
  },

<<<<<<< HEAD
=======
  setDirectionAttribute: () => {
    const htmlElement = document.querySelector('html');
    // If direction is already applied through props, do not apply again (iframe case)
    const hasDirApplied = htmlElement.getAttribute('data-dir-applied');
    if (!htmlElement || hasDirApplied) return;

    const localeFromHtml = htmlElement.lang;
    htmlElement.dir =
      localeFromHtml && getLanguageDirection(localeFromHtml) ? 'rtl' : 'ltr';
  },

>>>>>>> upstream/develop
  initializeThemesInPortal: initializeTheme,

  initialize: () => {
    openExternalLinksInNewTab();
<<<<<<< HEAD
=======
    InitializationHelpers.setDirectionAttribute();
>>>>>>> upstream/develop
    if (window.portalConfig.isPlainLayoutEnabled === 'true') {
      InitializationHelpers.appendPlainParamToURLs();
    } else {
      InitializationHelpers.initializeThemesInPortal();
      InitializationHelpers.navigateToLocalePage();
      InitializationHelpers.initializeSearch();
      InitializationHelpers.initializeTableOfContents();
<<<<<<< HEAD
=======
      InitializationHelpers.initializeSidebarThemeToggle();
      InitializationHelpers.initializeDetailsClickAway();
>>>>>>> upstream/develop
    }
  },

  onLoad: () => {
    InitializationHelpers.initialize();
    if (window.location.hash) {
      if ('scrollRestoration' in window.history) {
        window.history.scrollRestoration = 'manual';
      }

      const a = document.createElement('a');
      a.href = window.location.hash;
      a['data-turbolinks'] = false;
      a.click();
    }
  },
};
