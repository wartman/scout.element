#if macro
package scout.element.macro;

import haxe.macro.Expr;

class MetadataTools {

  public static function extract(meta:Metadata, names:Array<String>) {
    return meta.filter(m -> Lambda.has(names, m.name));
  }

  public static function hasEntry(meta:Metadata, names:Array<String>) {
    return Lambda.exists(meta, m -> Lambda.has(names, m.name));
  }

}
#end
