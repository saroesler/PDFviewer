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
 * Generic item list content plugin base class.
 */
class Pdfviewer_ContentType_Base_ItemList extends Content_AbstractContentType
{
    /**
     * The treated object type.
     *
     * @var string
     */
    protected $objectType;
    
    /**
     * The sorting criteria.
     *
     * @var string
     */
    protected $sorting;
    
    /**
     * The amount of desired items.
     *
     * @var integer
     */
    protected $amount;
    
    /**
     * Name of template file.
     *
     * @var string
     */
    protected $template;
    
    /**
     * Name of custom template file.
     *
     * @var string
     */
    protected $customTemplate;
    
    /**
     * Optional filters.
     *
     * @var string
     */
    protected $filter;
    
    /**
     * Returns the module providing this content type.
     *
     * @return string The module name.
     */
    public function getModule()
    {
        return 'Pdfviewer';
    }
    
    /**
     * Returns the name of this content type.
     *
     * @return string The content type name.
     */
    public function getName()
    {
        return 'ItemList';
    }
    
    /**
     * Returns the title of this content type.
     *
     * @return string The content type title.
     */
    public function getTitle()
    {
        $dom = ZLanguage::getModuleDomain('Pdfviewer');
    
        return __('Pdfviewer list view', $dom);
    }
    
    /**
     * Returns the description of this content type.
     *
     * @return string The content type description.
     */
    public function getDescription()
    {
        $dom = ZLanguage::getModuleDomain('Pdfviewer');
    
        return __('Display list of Pdfviewer objects.', $dom);
    }
    
    /**
     * Loads the data.
     *
     * @param array $data Data array with parameters.
     */
    public function loadData(&$data)
    {
        $serviceManager = ServiceUtil::getManager();
        $controllerHelper = new Pdfviewer_Util_Controller($serviceManager);
    
        $utilArgs = array('name' => 'list');
        if (!isset($data['objectType']) || !in_array($data['objectType'], $controllerHelper->getObjectTypes('contentType', $utilArgs))) {
            $data['objectType'] = $controllerHelper->getDefaultObjectType('contentType', $utilArgs);
        }
    
        $this->objectType = $data['objectType'];
    
        if (!isset($data['sorting'])) {
            $data['sorting'] = 'default';
        }
        if (!isset($data['amount'])) {
            $data['amount'] = 1;
        }
        if (!isset($data['template'])) {
            $data['template'] = 'itemlist_' . $this->objectType . '_display.tpl';
        }
        if (!isset($data['customTemplate'])) {
            $data['customTemplate'] = '';
        }
        if (!isset($data['filter'])) {
            $data['filter'] = '';
        }
    
        $this->sorting = $data['sorting'];
        $this->amount = $data['amount'];
        $this->template = $data['template'];
        $this->customTemplate = $data['customTemplate'];
        $this->filter = $data['filter'];
    }
    
    /**
     * Displays the data.
     *
     * @return string The returned output.
     */
    public function display()
    {
        $dom = ZLanguage::getModuleDomain('Pdfviewer');
        ModUtil::initOOModule('Pdfviewer');
    
        $entityClass = 'Pdfviewer_Entity_' . ucwords($this->objectType);
        $serviceManager = ServiceUtil::getManager();
        $entityManager = $serviceManager->getService('doctrine.entitymanager');
        $repository = $entityManager->getRepository($entityClass);
    
        $where = $this->filter;
    
        // ensure that the view does not look for templates in the Content module (#218)
        $this->view->toplevelmodule = 'Pdfviewer';
    
        $this->view->setCaching(Zikula_View::CACHE_ENABLED);
        // set cache id
        $component = 'Pdfviewer:' . ucwords($this->objectType) . ':';
        $instance = '::';
        $accessLevel = ACCESS_READ;
        if (SecurityUtil::checkPermission($component, $instance, ACCESS_COMMENT)) {
            $accessLevel = ACCESS_COMMENT;
        }
        if (SecurityUtil::checkPermission($component, $instance, ACCESS_EDIT)) {
            $accessLevel = ACCESS_EDIT;
        }
        $this->view->setCacheId('view|ot_' . $this->objectType . '_sort_' . $this->sorting . '_amount_' . $this->amount . '_' . $accessLevel);
    
        $template = $this->getDisplayTemplate();
    
        // if page is cached return cached content
        if ($this->view->is_cached($template)) {
            return $this->view->fetch($template);
        }
    
        $resultsPerPage = (($this->amount) ? $this->amount : 1);
    
        // get objects from database
        $selectionArgs = array(
            'ot' => $this->objectType,
            'where' => $where,
            'orderBy' => $this->getSortParam($repository),
            'currentPage' => 1,
            'resultsPerPage' => $resultsPerPage
        );
        list($entities, $objectCount) = ModUtil::apiFunc('Pdfviewer', 'selection', 'getEntitiesPaginated', $selectionArgs);
    
        $data = array('objectType' => $this->objectType,
                      'catids' => $this->catIds,
                      'sorting' => $this->sorting,
                      'amount' => $this->amount,
                      'template' => $this->template,
                      'customTemplate' => $this->customTemplate,
                      'filter' => $this->filter);
    
        // assign block vars and fetched data
        $this->view->assign('vars', $data)
                   ->assign('objectType', $this->objectType)
                   ->assign('items', $entities)
                   ->assign($repository->getAdditionalTemplateParameters('contentType'));
    
        $output = $this->view->fetch($template);
    
        return $output;
    }
    
    /**
     * Returns the template used for output.
     *
     * @return string the template path.
     */
    protected function getDisplayTemplate()
    {
        $templateFile = $this->template;
        if ($templateFile == 'custom') {
            $templateFile = $this->customTemplate;
        }
    
        $templateForObjectType = str_replace('itemlist_', 'itemlist_' . $this->objectType . '_', $templateFile);
    
        $template = '';
        if ($this->view->template_exists('contenttype/' . $templateForObjectType)) {
            $template = 'contenttype/' . $templateForObjectType;
        } elseif ($this->view->template_exists('contenttype/' . $templateFile)) {
            $template = 'contenttype/' . $templateFile;
        } else {
            $template = 'contenttype/itemlist_display.tpl';
        }
    
        return $template;
    }
    
    /**
     * Determines the order by parameter for item selection.
     *
     * @param Doctrine_Repository $repository The repository used for data fetching.
     *
     * @return string the sorting clause.
     */
    protected function getSortParam($repository)
    {
        if ($this->sorting == 'random') {
            return 'RAND()';
        }
    
        $sortParam = '';
        if ($this->sorting == 'newest') {
            $idFields = ModUtil::apiFunc('Pdfviewer', 'selection', 'getIdFields', array('ot' => $this->objectType));
            if (count($idFields) == 1) {
                $sortParam = $idFields[0] . ' DESC';
            } else {
                foreach ($idFields as $idField) {
                    if (!empty($sortParam)) {
                        $sortParam .= ', ';
                    }
                    $sortParam .= $idField . ' ASC';
                }
            }
        } elseif ($this->sorting == 'default') {
            $sortParam = $repository->getDefaultSortingField() . ' ASC';
        }
    
        return $sortParam;
    }
    
    /**
     * Displays the data for editing.
     */
    public function displayEditing()
    {
        return $this->display();
    }
    
    /**
     * Returns the default data.
     *
     * @return array Default data and parameters.
     */
    public function getDefaultData()
    {
        return array('objectType' => 'document',
                     'sorting' => 'default',
                     'amount' => 1,
                     'template' => 'itemlist_display.tpl',
                     'customTemplate' => '',
                     'filter' => '');
    }
    
    /**
     * Executes additional actions for the editing mode.
     */
    public function startEditing()
    {
        // ensure that the view does not look for templates in the Content module (#218)
        $this->view->toplevelmodule = 'Pdfviewer';
    
        // ensure our custom plugins are loaded
        array_push($this->view->plugins_dir, 'modules/Pdfviewer/templates/plugins');
    }
}