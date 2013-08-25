CKEDITOR.plugins.add('Pdfviewer', {
    requires: 'popup',
    lang: 'en,nl,de',
    init: function (editor) {
        editor.addCommand('insertPdfviewer', {
            exec: function (editor) {
                var url = Zikula.Config.baseURL + Zikula.Config.entrypoint + '?module=Pdfviewer&type=external&func=finder&editor=ckeditor';
                // call method in Pdfviewer_Finder.js and also give current editor
                PdfviewerFinderCKEditor(editor, url);
            }
        });
        editor.ui.addButton('pdfviewer', {
            label: 'Insert Pdfviewer object',
            command: 'insertPdfviewer',
         // icon: this.path + 'images/ed_pdfviewer.png'
            icon: '/images/icons/extrasmall/favorites.png'
        });
    }
});
