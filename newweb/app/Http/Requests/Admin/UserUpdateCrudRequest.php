<?php


namespace App\Http\Requests\Admin;

use EduardoArandaH\UserManager\app\Http\Requests\UserUpdateCrudRequest as EduardoArandaHUserUpdateCrudRequest;

class UserUpdateCrudRequest extends EduardoArandaHUserUpdateCrudRequest
{
    public function rules()
    {
        $baseRules = parent::rules();
        $baseRules['avatar'] = '';
        return $baseRules;
    }
}
