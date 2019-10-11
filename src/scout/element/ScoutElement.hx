package scout.element;

import haxe.ds.Map;
// import haxe.Timer;
import scout.html.Renderer;
import scout.html.TemplateResult;

enum ScoutElementState {
  StateBooting;
  StateUpdating;
  StateReady;
}

@:autoBuild(scout.element.macro.ScoutElementBuilder.build())
@:autoBuild(scout.element.macro.CustomElementBuilder.build())
class ScoutElement extends CustomElement {

  final _scout_properties:Map<String, Dynamic>;
  var _scout_state:ScoutElementState;

  public function new() {
    super();
    _scout_properties = [];
    _scout_state = StateBooting;
    _scout_init();
    _scout_state = StateReady;
    update();
  }

  function _scout_init() {
    // noop
  }

  public function setProperty(name:String, value:Dynamic) {
    _scout_properties.set(name, value);
    update();
  }

  public function getProperty(name:String) {
    return _scout_properties.get(name);
  }

  public function update() {
    if (shouldRender() && _scout_state == StateReady) {
      _scout_state = StateUpdating;
      var result = render();
      if (result != null) {
        Renderer.render(result, cast _scout_shadow);
      }
      _scout_state = StateReady;
    }
  }

  public function shouldRender():Bool {
    return true;
  }

  public function render():Null<TemplateResult> {
    return null;
  }

}
