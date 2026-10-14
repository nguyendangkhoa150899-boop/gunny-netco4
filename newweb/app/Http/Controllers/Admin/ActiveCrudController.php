<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Admin\Operations\ActiveAwardOperation;
use App\Http\Controllers\Admin\Operations\buildxmlOperation;
use App\Http\Controllers\Admin\Operations\CreateGiftCodeOperation;
use App\Http\Requests\ActiveRequest;
use App\Models\Active;
use App\Models\ActiveAward;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ActiveCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ActiveCrudController extends CrudController
{
    //use ActiveAwardOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use buildxmlOperation;
    use CreateGiftCodeOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     *
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\Active::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/active');
        CRUD::setEntityNameStrings('hoạt động', 'Hoạt động');
    }

    /**
     * Define what happens when the List operation is loaded.
     *
     * @see  https://backpackforlaravel.com/docs/crud-operation-list-entries
     * @return void
     */
    protected function setupListOperation()
    {
        $this->crud->addColumns([
            [
                'name'  => 'ActiveID',
                'label' => 'ActiveID',
                'type'  => 'text',
            ],
            [
                'name'  => 'Title',
                'label' => 'Title',
                'type'  => 'text',
            ],
            [
                'name'  => 'Description',
                'label' => 'Description',
                'type'  => 'text',
            ],
//            [
//                'name'  => 'AwardContent',
//                'label' => 'AwardContent',
//                'type'  => 'text',
//            ],
            [
                'name'  => 'StartDate',
                'label' => 'StartDate',
                'type'  => 'text',
            ],
            [
                'name'  => 'EndDate',
                'label' => 'EndDate',
                'type'  => 'text',
            ],
        ]);

        /**
         * Columns can be defined using the fluent syntax or array syntax:
         * - CRUD::column('price')->type('number');
         * - CRUD::addColumn(['name' => 'price', 'type' => 'number']);
         */
    }

    /**
     * Define what happens when the Create operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-create
     * @return void
     */
    protected function setupCreateOperation()
    {
        $this->crud->setValidation(ActiveRequest::class);

        $this->crud->addFields([
            [
                'name'  => 'ActiveID',
                'label' => "ActiveID",
                'type'  => 'number',
//                'hint' => 'Tiêu đề của hoạt động, hiển thị ở bên danh sách trái'
            ],
            [
                'name'  => 'Title',
                'label' => "Title",
                'type'  => 'text',
                'hint' => 'Tiêu đề của hoạt động, hiển thị ở bên danh sách trái'
            ],
            [
                'name'  => 'Description',
                'label' => 'Description',
                'type'  => 'textarea',
                'hint' => 'Mô tả hoạt động, thường là "Trong thời gian diễn ra sự kiện, hoàn thành điều kiện để nhận thưởng!"'
            ],
            [
                'name'  => 'Content',
                'label' => 'Content',
                'type'  => 'textarea',
                'hint' => 'Nội dung của hoạt động. Nêu rõ các điều kiện hoàn thành hoạt động'
            ],
            [
                'name'  => 'AwardContent',
                'label' => 'AwardContent',
                'type'  => 'textarea',
                'hint' => 'Phần thưởng: Mỗi phần thưởng trên 1 dòng'
            ],
//            [
//                'name'  => 'HasKey',
//                'label' => 'HasKey',
//                'type'  => 'checkbox',
//                'value' => 1,
//                'attributes' => [
//                    'disabled' => 1
//                ],
//                'hint' => 'Không biết giải thích sao cái trường này, để nó luôn = 1'
//            ],
            [   // date_range
                'name'  => ['StartDate', 'EndDate'], // db columns for start_date & end_date
                'label' => 'Thời gian',
                'type'  => 'date_range',

                // OPTIONALS
                // default values for start_date & end_date
                // 'default'            => ['2019-03-28 01:01', '2019-04-05 02:00'],
                // options sent to daterangepicker.js
                'date_range_options' => [
                    'timePicker' => true,
                    'locale' => ['format' => 'DD/MM/YYYY HH:mm']
                ]
            ],
            [
                'name'  => 'IsOnly',
                'label' => 'IsOnly',
                'type'  => 'checkbox',
                'hint' => '1 nhân vật chỉ được nhận 1 lần?'
            ],
            [   // radio
                'name'        => 'Type',
                'label'       => 'Type',
                'type'        => 'radio',
                'options'     => [
                    // the key will be stored in the db, the value will be shown as label;
                    1 => "Nhập Giftcode (1)",
                    2 => "Không biết (2)",
                    3 => "Nhận được luôn (3)",
                ],
                // optional
                'inline'      => true, // show the radios all on the same line?
            ],
            [   // Date
                'name'  => 'ActionTimeContent',
                'label' => 'ActionTimeContent',
                'type'  => 'text',
                'hint' => 'Không biết giải thích sao cái trường này!!!',
//                'date_picker_options' => [
//                    'todayBtn' => 'linked',
//                    'format'   => 'dd/mm/yyyy',
//                    'language' => 'vi'
//                ],
            ],
            [
                'name'  => 'CanGetCode',
                'label' => 'CanGetCode',
                'type'  => 'checkbox',
                'hint' => 'Check: người chơi có thể tự lấy code ở phần giftcode trong quản lý tài khoản'
            ],
            [
                'name'  => 'CodePrefix',
                'label' => 'CodePrefix',
                'type'  => 'text',
                'hint' => 'Tiền tố của giftcode khi tạo',
            ],
        ]);
        /**
         * Fields can be defined using the fluent syntax or array syntax:
         * - CRUD::field('price')->type('number');
         * - CRUD::addField(['name' => 'price', 'type' => 'number']));
         */
    }

    /**
     * Define what happens when the Update operation is loaded.
     *
     * @see https://backpackforlaravel.com/docs/crud-operation-update
     * @return void
     */
    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();

        $this->crud->addField([
            'name'      => 'awards',
            'label'     => 'Phần thưởng',
            'type'      => 'nested_crud',
            'target'    => 'award',
            'model'     => ActiveAward::class,
            'tab'       => 'Phần thưởng',  // optional
        ]);
    }

    public function buildxml()
    {
        $content = file_get_contents(
            trim(env('REQUEST_URL'), '/') . "/ActiveList.ashx"
        );
        if ($content === "Build:ActiveList.xml,Success!") {
            \Alert::success('Cập nhật ActiveList thành công!')->flash();
        } else {
            \Alert::error('Cập nhật thất bại, kiểm tra lại cấu hình!')->flash();
        }
        return back();
    }
}
