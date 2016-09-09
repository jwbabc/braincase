<?php
  // index.php
  // Set up autoload so you don't have to manually require all your classes:
  function __autoload($name)
  {
    if (strpos($name, 'Controller') !== false) {
      require 'controllers/' . $name . '.inc.php';
    }
  }

  // This gets the template you want; defaults to index.
  $view = isset($_GET['view']) ? $_GET['view'] : 'index';
  // This gets the action;
  $action = filter_input(INPUT_GET, 'action', FILTER_SANITIZE_STRING);

  // Pass to controller:
  $data = ControllerCommandFactory::execute($action);

  // Extract $data to global namespace.
  if (!is_null($data)) {
    extract($data);
  }

  require 'views/header.tpl.php';
  require $view_file;
  require 'views/footer.tpl.php';
?>

<?php
  // Then you have a file called controllers/ControllerCommand.inc.php:
  interface ControllerCommand {
    public function execute($action);
  }

  class ControllerCommandFactory {
    const ERROR_INVALID_ACTION = 601;

    // @codeCoverageIgnoreStart
    private function __construct() { }
    // @codeCoverageIgnoreStop

    public static function execute($action) {
      if ($action == '') {
        return null;
      }
      
      $controllers = array('UserController', 'SearchController', 'SecurityController');

      foreach ($controllers as $c) {
        $controller = new $c;
        if (($output = $controller->execute($action)) !== false) {
          return $output;
        }
      }

      throw new Exception('No implementation found for ' . $action, self::ERROR_INVALID_ACTION);
    }
  }
?>