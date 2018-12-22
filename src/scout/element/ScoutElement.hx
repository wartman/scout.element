package scout.element;

import js.html.Element;
import haxe.ds.Map;
// import haxe.Timer;
import scout.html.Renderer;
import scout.html.TemplateResult;
import scout.html.CustomElement;

enum ScoutElementState {
  StateBooting;
  StateUpdating;
  StateReady;
}

@:autoBuild(scout.element.macro.ScoutElementBuilder.build())
@:noElement
class ScoutElement extends CustomElement {

  // var timer:Timer;
  final properties:Map<String, Dynamic> = new Map();
  var __scout_state:ScoutElementState = StateBooting;

  public function new(el:Element) {
    super(el);
    __scout_init();
    __scout_state = StateReady;
    update();
  }

  function __scout_init() {
    // noop
  }

  // function requestUpdate() {
  //   if (timer != null) return;
  //   timer = Timer.delay(() -> {
  //     timer = null;
  //     update();
  //   }, 10);
  // }

  public function setProperty(name:String, value:Dynamic) {
    properties.set(name, value);
    update();
  }

  public function getProperty(name:String) {
    return properties.get(name);
  }

  public function update() {
    if (shouldRender() && __scout_state == StateReady) {
      __scout_state = StateUpdating;
      var result = render();
      if (result != null) {
        Renderer.render(result, el);
      }
      __scout_state = StateReady;
    }
  }

  public function shouldRender():Bool {
    return true;
  }

  public function render():Null<TemplateResult> {
    return null;
  }

}
