import { defineConfig } from 'vitepress'

export default defineConfig({
  title: "Fox's Dotfiles",
  description: 'A modern macOS development environment',
  base: '/dotfiles/',
  
  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: '/dotfiles/fox.svg' }],
    ['meta', { name: 'theme-color', content: '#f97316' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:title', content: "Fox's Dotfiles" }],
    ['meta', { property: 'og:description', content: 'A modern macOS development environment' }],
  ],

  themeConfig: {
    logo: '/fox.svg',
    
    nav: [
      { text: 'Guide', link: '/guide/getting-started' },
      { text: 'Reference', link: '/reference/tools' },
      { text: 'GitHub', link: 'https://github.com/Proteusiq/dotfiles' }
    ],

    sidebar: {
      '/guide/': [
        {
          text: 'Introduction',
          items: [
            { text: 'Getting Started', link: '/guide/getting-started' },
            { text: 'Installation', link: '/guide/installation' },
            { text: 'Architecture', link: '/guide/architecture' }
          ]
        },
        {
          text: 'Configuration',
          items: [
            { text: 'Shell (Zsh)', link: '/guide/shell' },
            { text: 'Neovim', link: '/guide/neovim' },
            { text: 'Terminal', link: '/guide/terminal' },
            { text: 'Git', link: '/guide/git' }
          ]
        }
      ],
      '/reference/': [
        {
          text: 'Reference',
          items: [
            { text: 'Tools', link: '/reference/tools' },
            { text: 'Keybindings', link: '/reference/keybindings' },
            { text: 'CLI Commands', link: '/reference/cli' },
            { text: 'Aliases', link: '/reference/aliases' }
          ]
        }
      ]
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/Proteusiq/dotfiles' }
    ],

    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Copyright 2024-present Prayson Wilfred Daniel'
    },

    search: {
      provider: 'local'
    },

    editLink: {
      pattern: 'https://github.com/Proteusiq/dotfiles/edit/main/docs/:path',
      text: 'Edit this page on GitHub'
    }
  }
})
