<?php

namespace App\Admin\Forms\Steps;

use App\ActiveAward;
use Encore\Admin\Grid;
use Encore\Admin\Widgets\StepForm;
use Illuminate\Http\Request;

class AddActiveItemAwardStep extends StepForm
{
    /**
     * The form title.
     *
     * @var  string
     */
    public $title = 'Basic info';

    /**
     * Handle the form request.
     *
     * @param  Request $request
     *
     * @return  \Illuminate\Http\RedirectResponse
     */
    public function handle(Request $request)
    {
        return $this->next($request->all());
    }

    /**
     * Build a form here.
     */
    public function form()
    {
//        $this->hasMany
        $this->number('ActiveID', __('ActiveID'));
//        $this->select('ItemID', 'Vật phẩm')->options([1 => 'foo', 2 => 'bar', 'val' => 'Option name']);
////            $this->number('ItemID', __('ItemID'));
//        $this->number('Count', __('Count'))->default(1);
//        $this->number('ValidDate', __('ValidDate'));
//        $this->number('StrengthenLevel', __('StrengthenLevel'));
//        $this->number('AttackCompose', __('AttackCompose'));
//        $this->number('DefendCompose', __('DefendCompose'));
//        $this->number('LuckCompose', __('LuckCompose'));
//        $this->number('AgilityCompose', __('AgilityCompose'));
//        $this->number('Gold', __('Gold'));
//        $this->number('Money', __('Money'));
//        $this->number('Sex', __('Sex'));
//        $this->number('Mark', __('Mark'));

        $this->table('ItemID', null, function ($form) {

            $form->select('ItemID', 'Vật phẩm')->options([1 => 'foo', 2 => 'bar', 'val' => 'Option name']);

            $form->number('ActiveID', __('ActiveID'));
//            $form->select('ItemID', 'Vật phẩm')->options([1 => 'foo', 2 => 'bar', 'val' => 'Option name']);
//            $form->number('ItemID', __('ItemID'));
            $form->number('Count', __('Count'))->default(1);
            $form->number('ValidDate', __('ValidDate'));
            $form->text('Composer', 'composer');
            $form->number('StrengthenLevel', __('StrengthenLevel'));
            $form->number('StrengthenLevel', __('StrengthenLevel'));
            $form->number('StrengthenLevel', __('StrengthenLevel'));
            $form->number('StrengthenLevel', __('StrengthenLevel'));
            $form->number('StrengthenLevel', __('StrengthenLevel'));
//            $form->number('AttackCompose', __('AttackCompose'));
//            $form->number('DefendCompose', __('DefendCompose'));
//            $form->number('LuckCompose', __('LuckCompose'));
//            $form->number('AgilityCompose', __('AgilityCompose'));
//            $form->number('Gold', __('Gold'));
            $form->number('Money', __('Money'));
            $form->number('Sex', __('Sex'));
//            $form->number('Mark', __('Mark'));
        });
        $this->setWidth(12,'100%');
//        $this->setWidth('ItemID','aas');

    }
}
