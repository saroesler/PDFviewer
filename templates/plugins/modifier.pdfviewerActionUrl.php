<?php
/**
 * Pdfviewer.
 *
 * @copyright Sascha Rösler (SR)
 * @license http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
 * @package Pdfviewer
 * @author Sascha Rösler <sa.roesler@st-marien-spandau.de>.
 * @link http://st-marien-spandau.de
 * @link http://zikula.org
 * @version Generated by ModuleStudio 0.6.0 (http://modulestudio.de) at Tue Jul 09 16:46:31 CEST 2013.
 */

/**
 * The pdfviewerActionUrl modifier creates the URL for a given action.
 *
 * @param string $urlType      The url type (admin, user, etc.)
 * @param string $urlFunc      The url func (view, display, edit, etc.)
 * @param array  $urlArguments The argument array containing ids and other additional parameters
 *
 * @return string Desired url in encoded form.
 */
function smarty_modifier_pdfviewerActionUrl($urlType, $urlFunc, $urlArguments)
{
    return DataUtil::formatForDisplay(ModUtil::url('Pdfviewer', $urlType, $urlFunc, $urlArguments));
}