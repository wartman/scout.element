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
    var connected:Array<Expr> = [];
    var onAttributeChange:Array<Expr> = [];

    for (f in fields) switch (f.kind) {
      case FVar(t, e):
        if (f.meta.exists(m -> m.name == ':property' || m.name == ':prop')) {
          f.kind = FProp('get', 'set', t, null);
          
          var params = f.meta.find(m -> m.name == ':property' || m.name == ':prop').params;
          var name = f.name;
          var getName = 'get_${name}';
          var setName = 'set_${name}';
          var attr:String = null;

          for (param in params) switch param {
            case macro attribute = ${ { expr: EConst(CString(s, _)), pos: pos } }:
              attr = s;
            default: Context.error('Invalid param', param.pos);
          }

          if (e != null) {
            initializers.push(macro this.$name = $e);
          }

          if (attr != null) {
            // todo: replace this with some method of syncing attrs
            connected.push(macro {
              if (getAttribute($v{attr}) != null) {
                setProperty($v{name}, getAttribute($v{attr}), { silent: true });
              } else {
                setAttribute($v{attr}, this.$name);
              }
            });
            onAttributeChange.push(macro if (name == $v{attr}) {
              setProperty($v{name}, value);
            });
          }

          newFields = newFields.concat((macro class {
            function $setName(value) {
              setProperty($v{name}, value);
              return value;
            }
            function $getName() return getProperty($v{name});
          }).fields);
        }
      default:
    }

    // if (initializers.length > 0) {
      fields = fields.concat((macro class {

        override function __init() {
          super.__init();
          $b{initializers};
        }

        override function __onConnected() {
          super.__onConnected();
          $b{connected};
        }

        override function attributeChangedCallback(name, old, value) {
          super.attributeChangedCallback(name, old, value);
          if (old != value) {
            $b{onAttributeChange};
          }
        }

      }).fields);
    // }

    // This is a dumb hack to get the constructor to generate
    // correctly. I don't know what I'm doing wrong TBH.
    fields = fields.concat((macro class {

      @:noCompletion var __wasConstructed:Bool = true;

    }).fields);

    return fields.concat(newFields);
  }

}
#end
