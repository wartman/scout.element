import js.Browser;
import todo.model.Todo;
import todo.view.*;
import scout.html.Template.html;

using scout.html.Renderer;

class Test {

  public static function main() {
    TodoInput.register();
    TodoList.register();
    TodoItem.register();

    var todos = [
      new Todo('0', 'Stuff', true),
      new Todo('1', 'Other Stuff', false),
      new Todo('2', 'More Stuff', false) 
    ];
    
    html('<todo-list .todos=${todos} />')
      .render(Browser.document.getElementById('root'));
  }

}
