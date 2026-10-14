<?php


namespace App\Http\Controllers\Admin;


use Backpack\CRUD\app\Http\Controllers\AdminController;

class DashboardController extends AdminController
{
    public function dashboard()
    {
        $this->data['title'] = trans('backpack::base.dashboard'); // set the page title
        $this->data['breadcrumbs'] = [
            trans('backpack::crud.admin')     => backpack_url('dashboard'),
            trans('backpack::base.dashboard') => false,
        ];

        return view(backpack_view('dashboard'), $this->data);
    }
}
