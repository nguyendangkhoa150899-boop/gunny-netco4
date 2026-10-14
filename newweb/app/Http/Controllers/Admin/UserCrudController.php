<?php


namespace App\Http\Controllers\Admin;

use EduardoArandaH\UserManager\app\Http\Controllers\UserCrudController as EduardoArandaHUserCrudController;
use App\Http\Requests\Admin\UserStoreCrudRequest;
use App\Http\Requests\Admin\UserUpdateCrudRequest;

class UserCrudController extends EduardoArandaHUserCrudController
{
    protected function addFields()
    {
        parent::addFields();
        $this->crud->addField([
            'label' => trans('usermanager.profile_image'),
            'name' => "avatar",
            'type' => 'image',
            'crop' => true, // set to true to allow cropping, false to disable
            'aspect_ratio' => 1,
        ]);
        $this->crud->addFields([
            [
                // two interconnected entities
                'label'             => trans('backpack::permissionmanager.user_role_permission'),
                'field_unique_name' => 'user_role_permission',
                'type'              => 'checklist_dependency',
                'name'              => ['roles', 'permissions'],
                'subfields'         => [
                    'primary' => [
                        'label'            => trans('backpack::permissionmanager.roles'),
                        'name'             => 'roles', // the method that defines the relationship in your Model
                        'entity'           => 'roles', // the method that defines the relationship in your Model
                        'entity_secondary' => 'permissions', // the method that defines the relationship in your Model
                        'attribute'        => 'name', // foreign key attribute that is shown to user
                        'model'            => config('permission.models.role'), // foreign key model
                        'pivot'            => true, // on create&update, do you need to add/delete pivot table entries?]
                        'number_columns'   => 3, //can be 1,2,3,4,6
                    ],
                    'secondary' => [
                        'label'          => ucfirst(trans('backpack::permissionmanager.permission_singular')),
                        'name'           => 'permissions', // the method that defines the relationship in your Model
                        'entity'         => 'permissions', // the method that defines the relationship in your Model
                        'entity_primary' => 'roles', // the method that defines the relationship in your Model
                        'attribute'      => 'name', // foreign key attribute that is shown to user
                        'model'          => config('permission.models.permission'), // foreign key model
                        'pivot'          => true, // on create&update, do you need to add/delete pivot table entries?]
                        'number_columns' => 3, //can be 1,2,3,4,6
                    ],
                ],
            ],
        ]);
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(UserStoreCrudRequest::class);
        $this->addFields();
    }

    protected function setupUpdateOperation()
    {
        $this->crud->setValidation(UserUpdateCrudRequest::class);
        $this->addFields();
    }
}
