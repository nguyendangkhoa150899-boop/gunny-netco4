<?php


namespace App\Http\Requests\Admin;

use EduardoArandaH\UserManager\app\Http\Requests\UserStoreCrudRequest as EduardoArandaHUserStoreCrudRequest;

class UserStoreCrudRequest extends EduardoArandaHUserStoreCrudRequest
{
    public function rules()
    {
        $baseRules = parent::rules();
        $baseRules['avatar'] = '';
        return $baseRules;
    }
}
