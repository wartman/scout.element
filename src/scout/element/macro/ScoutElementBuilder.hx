#if macro
package scout.element.macro;

import haxe.macro.Expr;
import haxe.macro.Context;

using Lambda;

class ScoutElementBuilder {

  public static function build() {
    var fields = Context.getBuildFields();
    var newFields:Array<Field> = [];
    var initializers:Array<Expr> = [];

    for (f in fields) switch (f.kind) {
      case FVar(t, e):
        if (f.meta.exists(m -> m.name == ':property' || m.name == ':prop')) {
          f.kind = FProp('get', 'set', t, null);
          var name = f.name;
          var getName = 'get_${name}';
          var setName = 'set_${name}';
          if (e != null) {
            initializers.push(macro this.$name = $e);
          }
          newFields = newFields.concat((macro class {
            function $setName(value) {
              setProperty($v{name}, value);
              return value;
            }
            function $getName() return getProperty($v{name});
          }).fields);
        }
        if (f.meta.exists(m -> m.name == ':attribute' || m.name == ':attr')) {
          f.kind = FProp('get', 'set', t, null);
          var params = f.meta.find(m -> m.name == ':attribute' || m.name == ':attr').params;
          var name = f.name;
          var attrName = params.length > 0 ? params[0] : macro $v{name};
          var getName = 'get_${name}';
          var setName = 'set_${name}';
          if (e != null) {
            initializers.push(macro this.$name = $e);
          }
          newFields = newFields.concat((macro class {
            function $setName(value) {
              setAttribute(${attrName}, value);
              return value;
            }
            function $getName() return getAttribute(${attrName});
          }).fields);
        }
      default:
    }

    if (initializers.length > 0) {
      fields = fields.concat((macro class {

        override function _scout_init() {
          super._scout_init();
          $b{initializers};
        }

      }).fields);
    }

    // This is a dumb hack to get the constructor to generate
    // correctly. I don't know what I'm doing wrong TBH.
    fields = fields.concat((macro class {

      var _scout_wasConstructed:Bool = true;

    }).fields);

    return fields.concat(newFields);
  }

}
#end
