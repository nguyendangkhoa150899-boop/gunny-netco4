# Dynamic Tank (Multiple Tank) development Notes & guideline

## List Dynamic Tank

Append in `grid` function

```php
protected function grid()
{
    $currentTank = Auth::guard('admin')->user()->current_tank;
    $model = new Model();
    $quest->setConnection($currentTank);

    $gird = new Grid($model);
}
```

## Edit Dynamic Tank

Append in `form` function

```php
protected function form()
{
    $currentTank = Auth::guard('admin')->user()->current_tank;
    $model = new Model();
    $quest->setConnection($currentTank);

    $form = new Form($model);

    $form->saving(function (Form $form) use ($currentTank){
		$form->model()->setConnection($currentTank);
    });
}
```

Create new `editForm` function

```php
public function editForm($id)
{
    //Generate form here

    $form->hidden('_method')->value('PUT');
    $form->setAction($form->resource().'/'.$OBJECYT->ID);
}
```

Override `edit` function

```php
 public function edit($id, Content $content)
 {
     return $content
         ->title($this->title())
         ->description($this->description['edit'] ?? 'Chỉnh sửa ')
         ->body($this->editForm($id));
 }
```


# Delete Dynamic Tank

Create new Action file in `Actions` folder

`Sample code`

```php
<?php

namespace App\Admin\Actions\CustomDelete\Quest;

use Encore\Admin\Actions\RowAction;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;

class DeleteQuestAction extends RowAction
{
    public $name = 'Xoá X';

    public function dialog()
    {
        $this->confirm('Bạn có chắc chắc muốn xoá X này không?');
    }

    public function handle(Model $model)
    {
        $currentTank = Auth::guard('admin')->user()->current_tank;

        $ID = $this->row->ID;
        $model = Model::on($currentTank)->findOrFail($ID);
        if($model->delete()){
            return $this->response()->success('Xoá X thành công')->refresh();
        }
        return $this->response()->error('Xoá X thất bại')->refresh();

    }

}

```

Append in `grid` function

```php
$grid->actions(function ($actions){
    $actions->disableDelete();
    $actions->add(new DeleteXYZAction());
});
```

# Edit In model



```php
public function __construct(array $attributes = [])
{
    $currentTank = Auth::guard('admin')->user()->current_tank;
    $this->connection = $currentTank;
    parent::__construct($attributes);
}
```
