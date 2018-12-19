#if macro
package scout.element.macro;

import haxe.macro.Expr;
import haxe.macro.Context;

using scout.element.macro.MetadataTools;

class ElementBuilder {

  static var id:Int = 0;

  public static function build() {
    var cls = Context.getLocalClass().get();
    var path = cls.pack.concat([ cls.name ]);
    var fields = Context.getBuildFields();
    var el = cls.meta.extract(':element');
    if (el.length == 0) {
      Context.error('`@:element` declaration is required', cls.pos);
    }

    // TEMP STUFF UNTIL HAXE CATCHES UP WITH THE PRESENT
    var name = el[0].params[0];
    var props = [ for (f in fields) switch (f.kind) {
      case FVar(t, e) if (f.meta.hasEntry([ ':prop', ':property' ])): f.name;
      default: null;
    } ].filter(n -> n != null);

    var tempCls = '(() => {
  class __Proxy{2} extends HTMLElement {
    constructor() {
      super();
      this.renderRoot = this.attachShadow({ mode: "open" });
      this.__v = new {1}(this, this.renderRoot);
    }
    connectedCallback() {
      this.__v.connectedCallback();
    }
    ${ [ for (prop in props) 'set $prop(value) { this.__v.$prop = value; }' ].join('\n') }
  }
  customElements.define({0}, __Proxy{2}, {});
})();';

    var attrs = getAttrs(fields);
    getProps(fields);

    fields = fields.concat((macro class {

      /////// START TEMP SHIM ///////

      public static function __init__() {
        js.Syntax.code($v{tempCls}, ${name}, $p{path}, $v{id++});
        // untyped customElements.define(${name}, $p{path}, {});
      }

      /////// END TEMP SHIM ///////

      override function gatherAttributes() {
        $b{attrs};
      }

    }).fields);
    
    return fields;
  }

  static function getAttrs(fields:Array<Field>):Array<Expr> {
    var body:Array<Expr> = [];
    for (f in fields) switch (f.kind) {
      case FVar(t, e) if (f.meta.hasEntry([ ':attr', ':attribute' ])):
        // var meta = f.meta.extract([ ':attr', ':attribute' ]);
        var name = f.name;
        body.push(macro this.$name = getAttribute($v{name}));
      default:
    }
    return body;
  }

  static function getProps(fields:Array<Field>):Void {
    for (f in fields) switch (f.kind) {
      case FVar(t, e) if (f.meta.hasEntry([ ':prop', ':property' ])):
        f.kind = FProp('get', 'set', t);
        f.meta.push({ name: ':isVar', params: [], pos: f.pos });
        var name = f.name;
        var getName = 'get_${name}';
        var setName = 'set_${name}';
        var newFields = (macro class {
          public function $getName() {
            return this.$name;
          }
          public function $setName(value) {
            this.$name = value;
            this.update();
            return this.$name;
          }
        }).fields;
        for (f in newFields) {
          fields.push(f);
        }
      default:
    }
  }

}
#end
