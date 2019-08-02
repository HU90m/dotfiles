# Background color of unselected even and odd tabs.
c.colors.tabs.even.bg = '#000000'
c.colors.tabs.odd.bg  = '#000000'

# Foreground color of unselected even and odd tabs.
c.colors.tabs.even.fg = '#cccccc'
c.colors.tabs.odd.fg  = '#cccccc'

# Background color of selected even and odd tabs.
c.colors.tabs.selected.even.bg = '#cccccc'
c.colors.tabs.selected.odd.bg  = '#cccccc'

# Foreground color of selected even and odd tabs.
c.colors.tabs.selected.even.fg = '#000000'
c.colors.tabs.selected.odd.fg  = '#000000'

# Search engines which can be used via the address bar. Maps a search
# engine name (such as `DEFAULT`, or `ddg`) to a URL with a `{}`
# placeholder. The placeholder will be replaced by the search term, use
# `{{` and `}}` for literal `{`/`}` signs. The search engine named
# `DEFAULT` is used when `url.auto_search` is turned on and something
# else than a URL was entered to be opened. Other search engines can be
# used by prepending the search engine name to the search term, e.g.
# `:open google qutebrowser`.
# Type: Dict
c.url.searchengines = {
    'DEFAULT': 'https://www.duckduckgo.com/?q={}',
    'wikipedia': 'https://en.wikipedia.org/w/index.php?search={}',
    'google': 'https://google.com/search?q={}',
    'maps': 'https://maps.google.com/?q={}'
}

# Page(s) to open at the start.
# Type: List of FuzzyUrl, or FuzzyUrl
c.url.start_pages = ['about:blank']

# Page to open if :open -t/-b/-w is used without URL. Use `about:blank`
# for a blank page.
# Type: FuzzyUrl
c.url.default_page = 'about:blank'

# Default monospace fonts. Whenever "monospace" is used in a font
# setting, it's replaced with the fonts listed here.
# Type: Font
c.fonts.monospace = 'Monospace, "Noto Sans Mono"'

# Always restore open sites when qutebrowser is reopened.
# Type: Bool
c.auto_save.session = True

# How to behave when the last tab is closed.
# Type: String
# Valid values:
#   - ignore: Don't do anything.
#   - blank: Load a blank page.
#   - startpage: Load the start page.
#   - default-page: Load the default page.
#   - close: Close the window.
c.tabs.last_close = 'close'

## Require a confirmation before quitting the application.
## Type: ConfirmQuit
## Valid values:
##   - always: Always show a confirmation.
##   - multiple-tabs: Show a confirmation if multiple tabs are opened.
##   - downloads: Show a confirmation if downloads are running
##   - never: Never show a confirmation.
c.confirm_quit = ['always']
