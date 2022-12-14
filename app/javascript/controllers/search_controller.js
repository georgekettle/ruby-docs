import { Controller } from "@hotwired/stimulus"
import { algoliasearch } from 'algoliasearch'

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input", "results", "hitTemplate"]
  static values = {
    rubyVersion: String,
    algoliaId: String,
    algoliaPublicKey: String,
    indexName: String,
    loadingHtml: { 
      type: String,
      default: `<div class="flex justify-center items-center p-8">
                  <span class="flex h-3 w-3 relative">
                    <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary-400 opacity-75"></span>
                    <span class="relative inline-flex rounded-full h-3 w-3 bg-primary-500"></span>
                  </span>
                  <span class="ml-2 text-sm text-slate-400">Searching docs...</span>
                </div>`
    }
  }

  connect() {
    if (this.hasAlgoliaIdValue && this.hasAlgoliaPublicKeyValue && this.hasIndexNameValue) {
      this.initSearch()
    } else {
      console.warn('Search not working: Please provide correct values for search_controller.js')
    }
  }

  initSearch() {
    // Connect and authenticate with your Algolia app
    this.client = algoliasearch(
      this.algoliaIdValue,
      this.algoliaPublicKeyValue
    )
  }

  async search(e) {
    this._displayLoading()
    const query = this.inputTarget.value
    // Fetch search results
    const { results } = await this.client.search({
      requests: [
        // request for klasses
        {
          indexName: this.indexNameValue,
          query: query,
          hitsPerPage: 5,
          filters: `version_number:${this.rubyVersionValue} AND class:Klass`,
          attributesToHighlight: ['*'],
          highlightPreTag: '<span class="text-yellow-500 group-hover:text-white">',
          highlightPostTag: '</span>'
        },
        // request for sections
        {
          indexName: this.indexNameValue,
          query: query,
          hitsPerPage: 5,
          filters: `version_number:${this.rubyVersionValue} AND class:Section`,
          attributesToHighlight: ['*'],
          highlightPreTag: '<span class="text-yellow-500 group-hover:text-white">',
          highlightPostTag: '</span>'
        }
      ],
    })
    this._removeLoading()
    this._displayResults(results)
  }

  _displayResults(results) {
    console.log(results)
    if (results[0].hits.length > 0) {
      this._displayKlassResults(results[0])
    }

    if (results[1].hits.length > 0) {
      this._displaySectionResults(results[1])
    }
    
    if ((results[1].hits.length === 0) && (results[0].hits.length === 0)) {
      this._displayNoResults()
    }
  }

  _displayKlassResults(results) {
    const hits = results.hits
    let html
    if (hits.length > 0) {
      const htmlHits = hits.map(hit => {
        return this._renderKlassHTML(hit)
      })
      html = htmlHits.join('')
    } else {
      html = this._renderEmptyState('classes')
    }
    const htmlKlassResults = `<div class="mb-4">
                                  <p class="pb-4 text-md font-semibold dark:text-slate-200">Classes</p>
                                  <ul data-search-target="results">
                                    ${html}
                                  </ul>
                                </div>`
    this.resultsTarget.insertAdjacentHTML('afterbegin', htmlKlassResults)
  }

  _displaySectionResults(results) {
    const hits = results.hits
    let html
    if (hits.length > 0) {
      const htmlHits = hits.map(hit => {
        return this._renderSectionHTML(hit)
      })
      html = htmlHits.join('')
    } else {
      html = this._renderEmptyState('methods')
    }
    const htmlSectionResults = `<div class="mb-4">
                                  <p class="pb-4 text-md font-semibold dark:text-slate-200">Methods</p>
                                  <ul data-search-target="results">
                                    ${html}
                                  </ul>
                                </div>`
    this.resultsTarget.insertAdjacentHTML('beforeend', htmlSectionResults)
  }

  _sectionTitle = (section, highlightResult) => {
    const separator = (section.category === 'instance_method') ? '#' : '::'
    return `<span class="opacity-40 group-hover:opacity-50">${highlightResult.klass_name.value}</span> ${separator} ${highlightResult.name.value}`
  }

  _renderSectionHTML = (section) => {
    const highlightResult = section._highlightResult
    const title = this._sectionTitle(section, highlightResult)
    const summary = this._formatSummary(section.summary, highlightResult.summary)
    return(`<li class="pb-2">
              <a href="/sections/${section.id}" class="group p-4 bg-slate-50 rounded-xl inline-block w-full hover:bg-primary-500 hover:text-white dark:bg-slate-700 dark:hover:bg-slate-900 dark:hover:text-slate-300">
                <div class="flex items-center">
                  <div class="shrink-0 mr-4 w-6 h-6 flex items-center justify-center rounded-md bg-white group-hover:bg-transparent inline-block text-slate-400 group-hover:text-white dark:group-hover:text-slate-800 ring-1 ring-slate-900/5 shadow-sm group-hover:shadow-none group-hover:ring-primary-400 dark:ring-0 dark:shadow-none dark:group-hover:shadow-none dark:group-hover:highlight-white/10 group-hover:shadow-primary-200 dark:group-hover:bg-slate-200 dark:bg-slate-700 dark:highlight-white/5">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" class="h-5 w-5 h-4 w-4">
                      <path fill-rule="evenodd" d="M11.097 1.515a.75.75 0 01.589.882L10.666 7.5h4.47l1.079-5.397a.75.75 0 111.47.294L16.665 7.5h3.585a.75.75 0 010 1.5h-3.885l-1.2 6h3.585a.75.75 0 010 1.5h-3.885l-1.08 5.397a.75.75 0 11-1.47-.294l1.02-5.103h-4.47l-1.08 5.397a.75.75 0 01-1.47-.294l1.02-5.103H3.75a.75.75 0 110-1.5h3.885l1.2-6H5.25a.75.75 0 010-1.5h3.885l1.08-5.397a.75.75 0 01.882-.588zM10.365 9l-1.2 6h4.47l1.2-6h-4.47z" clip-rule="evenodd"></path>
                    </svg>
                  </div>
                  <div>
                    <p class="text-xs font-semibold py-1 px-2 rounded-full bg-slate-100 inline-block group-hover:text-white group-hover:bg-white/10 mb-1 dark:bg-black/10">${title}</p>
                    <h5 class="font-normal text-sm group-hover:text-primary-300 text-slate-400 dark:group-hover:text-slate-400 line-clamp-1">${summary}</h5>
                  </div>
                </div>
              </a>
            </li>`)
  }

  _renderKlassHTML = (klass) => {
    const highlightResult = klass._highlightResult
    const summary = this._formatSummary(klass.summary, highlightResult.summary)
    return(`<li class="pb-2">
              <a href="/klasses/${klass.id}" class="group p-4 bg-slate-50 rounded-xl inline-block w-full hover:bg-primary-500 hover:text-white dark:bg-slate-700 dark:hover:bg-slate-900 dark:hover:text-slate-300">
                <div class="flex items-center">
                  <div class="shrink-0 mr-4 w-6 h-6 flex items-center justify-center rounded-md bg-white text-slate-400 group-hover:text-white dark:group-hover:text-slate-800 ring-1 ring-slate-900/5 shadow-sm group-hover:shadow-none group-hover:ring-primary-400 dark:ring-0 dark:shadow-none dark:group-hover:shadow-none dark:group-hover:highlight-white/10 group-hover:shadow-primary-200 dark:group-hover:bg-slate-200 dark:bg-slate-700 dark:highlight-white/5">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" class="h-5 w-5 h-4 w-4 m-1 group-hover:text-primary-500 dark:group-hover:text-slate-800">
                      <path d="M12.378 1.602a.75.75 0 00-.756 0L3 6.632l9 5.25 9-5.25-8.622-5.03zM21.75 7.93l-9 5.25v9l8.628-5.032a.75.75 0 00.372-.648V7.93zM11.25 22.18v-9l-9-5.25v8.57a.75.75 0 00.372.648l8.628 5.033z"></path>
                    </svg>
                  </div>
                  <div>
                    <p class="text-xs font-semibold py-1 px-2 rounded-full bg-slate-100 inline-block group-hover:text-white group-hover:bg-white/10 mb-1 dark:bg-black/10">${klass.name}</p>
                    <h5 class="font-normal text-sm group-hover:text-primary-300 text-slate-400 dark:group-hover:text-slate-400 line-clamp-1">${summary}</h5>
                  </div>
                </div>
              </a>
            </li>`)
  }

  _displayLoading() {
    this.resultsTarget.innerHTML = this.loadingHtmlValue
  }

  _displayNoResults() {
    this.resultsTarget.innerHTML = `<div class="p-8">
                                      <p class="font-normal text-sm text-slate-400 text-center mb-4">We looked both ways, but couldn't find any results for your search</p>
                                      <div class="w-full pointer-events-none overflow-hidden rounded-xl shadow">
                                        <div style="width:100%;height:0;padding-bottom:56%;position:relative;">
                                          <iframe src="https://giphy.com/embed/28cUPIfjtmKVYO8flA" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe>
                                        </div>
                                      </div>
                                    </div>`
  }

  _removeLoading() {
    this.resultsTarget.innerHTML = ''
  }

  _renderEmptyState = (itemsName) => {
    return(`<div class="p-6 md:p-8 text-slate-400 border border-slate-100 rounded-lg shadow-sm dark:bg-slate-800 dark:highlight-white/5 dark:border-slate-800">
              <div class="flex items-center justify-center">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true" class="h-5 w-5 h-5 w-5 mr-2">
                  <path fill-rule="evenodd" d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12zm8.706-1.442c1.146-.573 2.437.463 2.126 1.706l-.709 2.836.042-.02a.75.75 0 01.67 1.34l-.04.022c-1.147.573-2.438-.463-2.127-1.706l.71-2.836-.042.02a.75.75 0 11-.671-1.34l.041-.022zM12 9a.75.75 0 100-1.5.75.75 0 000 1.5z" clip-rule="evenodd"></path>
                </svg>
                <p class="font-normal">No ${itemsName} found for search</p>
              </div>
            </div>`)
  }

  _formatSummary(summary, highlightSummary) {
    if (highlightSummary && highlightSummary.value) {
      const regex = /.{0,30}<span.*>.*<\/span.*>.{0,30}/g
      const matches = highlightSummary.value.match(regex)
      return `...${matches[0]}...`
    } else {
      return summary
    }
  }
}