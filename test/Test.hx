import js.Browser;
import scout.html.Api.html;
import todo.model.Todo;
import todo.view.TodoList;

using scout.html.Renderer;

class Test {

  public static function main() {
    var todos = [
      new Todo('0', 'Stuff', true),
      new Todo('1', 'Other Stuff', false),
      new Todo('2', 'More Stuff', false) 
    ];
    html('<todo-list .todos="${todos}" />')
      .render(Browser.document.getElementById('root'));
  }

}
