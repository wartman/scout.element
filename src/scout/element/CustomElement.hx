package scout.element;

import js.html.Element;
import js.html.ShadowRoot;

@:native('ScoutCustomElement')
extern class CustomElement extends Element {
  var _scout_shadow:ShadowRoot;
}