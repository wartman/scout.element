package scout.element;

import haxe.ds.Map;
// import haxe.Timer;
import scout.html.Renderer;
import scout.html.TemplateResult;

enum ScoutElementState {
  StateDisconnected;
  StateBooting;
  StateUpdating;
  StateReady;
}

@:autoBuild(scout.element.macro.ScoutElementBuilder.build())
@:autoBuild(scout.element.macro.CustomElementBuilder.build())
class ScoutElement extends CustomElement {

  final __properties:Map<String, Dynamic>;
  var __state:ScoutElementState;

  public function new() {
    super();
    __state = StateDisconnected;
    __properties = [];
    __init();
  }

  function __init() {
    // noop
  }

  function __onConnected() {
    // noop
  }

  public function connectedCallback() {
    __state = StateBooting;
    __onConnected();
    __state = StateReady;
    update();
  }

  public function disconnectedCallback() {
    __state = StateDisconnected;
  }

  public function attributeChangedCallback(name:String, old:Null<String>, value:Null<String>) {
    // noop
  }

  public function setProperty(name:String, value:Dynamic, ?options:{ silent:Bool }) {
    __properties.set(name, value);
    if (options != null && options.silent) return;
    if (__state == StateReady) update();
  }

  public function getProperty(name:String) {
    return __properties.get(name);
  }

  public function update() {
    if (shouldRender() && __state == StateReady) {
      __state = StateUpdating;
      var result = render();
      if (result != null) {
        Renderer.render(result, cast __shadow);
      }
      __state = StateReady;
    }
  }

  public function shouldRender():Bool {
    return true;
  }

  public function render():Null<TemplateResult> {
    return null;
  }

}
