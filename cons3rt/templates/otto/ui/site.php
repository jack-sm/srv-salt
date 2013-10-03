<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/*
|--------------------------------------------------------------------------
| Base Site URL
|--------------------------------------------------------------------------
|
| URL to the base installation.
|
*/
$config['base_url']	= 'https://www.testforge.ceif.hpc.mil/';

/*
|--------------------------------------------------------------------------
| Instance name
|--------------------------------------------------------------------------
|
| Title of the site (displayed on the welcome page).
|
*/
$config['instance_name'] = 'Hanscom milCloud';

/*
|--------------------------------------------------------------------------
| Install location
|--------------------------------------------------------------------------
|
| Location of the site (displayed on the welcome page).
|
*/
$config['instance_location'] = 'Hanscom Air Force Base';

/*
|--------------------------------------------------------------------------
| Login URL
|--------------------------------------------------------------------------
|
| URL to the CONS3RT login module.
|
*/
$config['login_url'] = $config['base_url'].'login';

/*
|--------------------------------------------------------------------------
| REST URL
|--------------------------------------------------------------------------
|
| URL to the root of the REST service.
|
*/
$config['rest_url'] = $config['base_url'].'rest/';

/*
|--------------------------------------------------------------------------
| Require agreement
|--------------------------------------------------------------------------
|
| Whether to require notice and consent agreement.
|
*/
$config['require_agreement'] = TRUE;

/*
|--------------------------------------------------------------------------
| Show banner
|--------------------------------------------------------------------------
|
| Whether to show the FOUO banner.
|
*/
$config['show_banner'] = TRUE;

/*
|--------------------------------------------------------------------------
| Capabilities
|--------------------------------------------------------------------------
|
| Properties of the installation for a given site.
|
*/
$config['clouds'] 					= array('Hanscom Cloud');
$config['virtualization_services'] 	= array('VMWare vCloud');
$config['provisioning_services'] 	= array('CONS3RT FAP');
$config['build_services'] 			= array('maven');
$config['test_services'] 			= array('iTKO Lisa', 'soapUI', 'Retina');
$config['misc_services'] 			= array();


/* End of file site.php */
/* Location: ./application/config/site.php */
