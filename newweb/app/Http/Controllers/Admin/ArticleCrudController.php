<?php


namespace App\Http\Controllers\Admin;


use App\Http\Requests\ArticleRequest;

class ArticleCrudController extends \Backpack\NewsCRUD\app\Http\Controllers\Admin\ArticleCrudController
{
    public function setup()
    {
        /*
        |--------------------------------------------------------------------------
        | BASIC CRUD INFORMATION
        |--------------------------------------------------------------------------
        */
        $this->crud->setModel(\App\Models\Article::class);
        $this->crud->setRoute(config('backpack.base.route_prefix', 'admin').'/article');
        $this->crud->setEntityNameStrings('article', 'articles');
        $this->crud->denyAccess(['show']);

        /*
        |--------------------------------------------------------------------------
        | LIST OPERATION
        |--------------------------------------------------------------------------
        */
        $this->crud->operation('list', function () {
            $this->crud->addColumn('title');
            $this->crud->addColumn([
                'name' => 'date',
                'label' => 'Date',
                'type' => 'date',
            ]);
            $this->crud->addColumn('status');
            $this->crud->addColumn([
                'name' => 'featured',
                'label' => 'Featured',
                'type' => 'check',
            ]);
        });

        /*
        |--------------------------------------------------------------------------
        | CREATE & UPDATE OPERATIONS
        |--------------------------------------------------------------------------
        */
        $this->crud->operation(['create', 'update'], function () {
            $this->crud->setValidation(ArticleRequest::class);

            $this->crud->addField([
                'name' => 'title',
                'label' => 'Title',
                'type' => 'text',
                'placeholder' => 'Your title here',
            ]);
            $this->crud->addField([
                'name' => 'slug',
                'label' => 'Slug (URL)',
                'type' => 'text',
                'hint' => 'Will be automatically generated from your title, if left empty.',
                // 'disabled' => 'disabled'
            ]);
            $this->crud->addField([
                'name' => 'date',
                'label' => 'Date',
                'type' => 'date',
                'default' => date('Y-m-d'),
            ]);
            $this->crud->addField([
                'name' => 'description',
                'label' => 'Description',
                'type' => 'textarea',
                'placeholder' => 'Mô tả bài viết',
            ]);
            $this->crud->addField([
                'name' => 'content',
                'label' => 'Content',
                'type' => 'ckeditor',
                'placeholder' => 'Nội dung bài viết',
            ]);
            $this->crud->addField([
                'name' => 'image',
                'label' => 'Image',
                'type' => 'browse',
            ]);
            $this->crud->addField([
                'name' => 'status',
                'label' => 'Status',
                'type'        => 'select_from_array',
                'options'     => ['PUBLISHED' => 'PUBLISHED', 'DRAFTED' => 'DRAFTED'],
                'allows_null' => false,
                'default'     => 'PUBLISHED',
            ]);
            $this->crud->addField([
                'name' => 'featured',
                'label' => 'Featured item',
                'type' => 'checkbox',
            ]);
        });
    }
}
