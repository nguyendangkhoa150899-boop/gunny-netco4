<?php

/**
 * Laravel-admin - admin builder based on Laravel.
 * @author z-song <https://github.com/z-song>
 *
 * Bootstraper for Admin.
 *
 * Here you can remove builtin form field:
 * Encore\Admin\Form::forget(['map', 'editor']);
 *
 * Or extend custom form field:
 * Encore\Admin\Form::extend('php', PHPEditor::class);
 *
 * Or require js and css assets:
 * Admin::css('/packages/prettydocs/css/styles.css');
 * Admin::js('/packages/prettydocs/js/main.js');
 *
 */

use App\ServerList;
use Encore\Admin\Facades\Admin;

Encore\Admin\Form::forget(['map', 'editor']);
$tankList = ServerList::all();
$admin = \Illuminate\Support\Facades\Auth::guard('admin')->user();
if($admin)
    $currentTank = $admin->current_tank;
else
    $currentTank = 'sqlsrv_tank';
Admin::navbar(function (\Encore\Admin\Widgets\Navbar $navbar) use ($tankList, $currentTank) {

    $navbar->left(view('admin.header.select-tank', compact(['tankList', 'currentTank'])));

});

Admin::style('.visible-lg-block { display: block !important;} ');

Admin::css('/assets/css/custom-header.css');


