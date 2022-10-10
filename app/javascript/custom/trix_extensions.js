import Trix from 'trix';

window.Trix = Trix; // Don't need to bind to the window, but useful for debugging.
Trix.config.toolbar.getDefaultHTML = toolbarDefaultHTML;

// trix-before-initialize runs too early.
// We only need to do this once. Everything after initialize will get the
// defaultHTML() call automatically.
document.addEventListener('trix-initialize', updateToolbars, { once: true });
document.addEventListener('trix-change', applyAttributes);

function updateToolbars(event) {
  const toolbars = document.querySelectorAll('trix-toolbar');
  const html = Trix.config.toolbar.getDefaultHTML();
  toolbars.forEach((toolbar) => (toolbar.innerHTML = html));
}

Trix.config.textAttributes.underline = {
  tagName: 'u'
}
Trix.config.blockAttributes.code = {
  tagName: 'pre'
}
Trix.config.blockAttributes.heading2 = {
  tagName: 'h2'
}
Trix.config.blockAttributes.heading3 = {
  tagName: 'h3'
}
const {lang} = Trix.config;
/**
 * This is the default Trix toolbar. Feel free to change / manipulate it how you would like.
 * see https://github.com/basecamp/trix/blob/main/src/trix/config/toolbar.coffee
 */
function toolbarDefaultHTML() {
  const {lang} = Trix.config;
  return `
    <div class="bg-slate-50 border border-slate-200 rounded-md p-2 flex items-center overflow-x-auto text-slate-400">
     <span class="flex items-center" data-trix-button-group="text-tools">
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-attribute="bold" data-trix-key="b" title="${lang.bold}" tabindex="-1"><i class="fa-solid fa-bold w-4"></i></button>
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-attribute="italic" data-trix-key="i" title="${lang.italic}" tabindex="-1"><i class="fa-solid fa-italic w-4"></i></button>
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-attribute="strike" title="${lang.strike}" tabindex="-1"><i class="fa-solid fa-strikethrough w-4"></i></button>
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-attribute="underline" data-trix-key="u" title="underline" tabindex="-1"><i class="fa-solid fa-underline w-4"></i></button>
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-attribute="href" data-trix-action="link" data-trix-key="k" title="${lang.link}" tabindex="-1"><i class="fa-solid fa-link w-4"></i></button>
     </span>
     <span class="flex items-center" data-trix-button-group="block-tools">
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-attribute="heading2" title="${lang.heading2}" tabindex="-1">
        <div class="flex items-end">   
          <i class="fa-solid fa-heading w-4"></i><span class="text-xs leading-3">2</span>
        </div>
       </button>
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-attribute="heading3" title="${lang.heading3}" tabindex="-1">
        <div class="flex items-end">   
          <i class="fa-solid fa-heading w-4"></i><span class="text-xs leading-3">3</span>
        </div>
       </button>
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-attribute="quote" title="${lang.quote}" tabindex="-1"><i class="fa-solid fa-quote-right w-4"></i></button>
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-attribute="code" title="${lang.code}" tabindex="-1"><i class="fa-solid fa-code w-4"></i></button>
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-attribute="bullet" title="${lang.bullets}" tabindex="-1"><i class="fa-solid fa-list-ul w-4"></i></button>
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-attribute="number" title="${lang.numbers}" tabindex="-1"><i class="fa-solid fa-list-ol w-4"></i></button>
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-action="decreaseNestingLevel" title="${lang.outdent}" tabindex="-1"><i class="fa-solid fa-outdent w-4"></i></button>
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-action="increaseNestingLevel" title="${lang.indent}" tabindex="-1"><i class="fa-solid fa-indent w-4"></i></button>
     </span>
     <span class="flex items-center" data-trix-button-group="file-tools">
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200 trix-button--icon-attach" data-trix-action="attachFiles" title="${lang.attachFiles}" tabindex="-1"><i class="fa-solid fa-paperclip w-4"></i></button>
     </span>
     <span class="flex-grow"></span>
     <span class="flex items-center" data-trix-button-group="history-tools">
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-action="undo" data-trix-key="z" title="${lang.undo}" tabindex="-1"><i class="fa-solid fa-rotate-left w-4"></i></button>
       <button type="button" class="h-8 w-8 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" data-trix-action="redo" data-trix-key="shift+z" title="${lang.redo}" tabindex="-1"><i class="fa-solid fa-rotate-right w-4"></i></button>
     </span>
   </div>
   <div class="trix-dialogs" data-trix-dialogs>
     <div class="trix-dialog trix-dialog--link" data-trix-dialog="href" data-trix-dialog-attribute="href">
       <div class="trix-dialog__link-fields">
         <input type="url" name="href" class="trix-input trix-input--dialog" placeholder="${lang.urlPlaceholder}" aria-label="${lang.url}" required data-trix-input>
         <div class="trix-button-group">
           <input type="button" class="p-2 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" value="${lang.link}" data-trix-method="setAttribute">
           <input type="button" class="p-2 flex items-center justify-center rounded hover:bg-slate-200 hover:text-slate-900 transition duration-200" value="${lang.unlink}" data-trix-method="removeAttribute">
         </div>
       </div>
     </div>
   </div>
  `;
}

function applyAttributes(e) {
}