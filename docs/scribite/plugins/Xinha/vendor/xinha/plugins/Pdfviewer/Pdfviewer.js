// Pdfviewer plugin for Xinha
// developed by Sascha Rösler
//
// requires Pdfviewer module (http://st-marien-spandau.de)
//
// Distributed under the same terms as xinha itself.
// This notice MUST stay intact for use (see license.txt).

'use strict';

function Pdfviewer(editor) {
    var cfg, self;

    this.editor = editor;
    cfg = editor.config;
    self = this;

    cfg.registerButton({
        id       : 'Pdfviewer',
        tooltip  : 'Insert Pdfviewer object',
     // image    : _editor_url + 'plugins/Pdfviewer/img/ed_Pdfviewer.gif',
        image    : '/images/icons/extrasmall/favorites.png',
        textMode : false,
        action   : function (editor) {
            var url = Zikula.Config.baseURL + 'index.php'/*Zikula.Config.entrypoint*/ + '?module=Pdfviewer&type=external&func=finder&editor=xinha';
            PdfviewerFinderXinha(editor, url);
        }
    });
    cfg.addToolbarElement('Pdfviewer', 'insertimage', 1);
}

Pdfviewer._pluginInfo = {
    name          : 'Pdfviewer for xinha',
    version       : '1.0.0',
    developer     : 'Sascha Rösler',
    developer_url : 'http://st-marien-spandau.de',
    sponsor       : 'ModuleStudio 0.6.0',
    sponsor_url   : 'http://modulestudio.de',
    license       : 'htmlArea'
};
