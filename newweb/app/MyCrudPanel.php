<?php

namespace App;

class MyCrudPanel extends \Backpack\CRUD\app\Library\CrudPanel\CrudPanel
{
    protected bool $hasOrderByPrimaryKey = true;

    public function setHasOrderByPrimaryKey($needed = true)
    {
        $this->hasOrderByPrimaryKey = $needed;
    }

    public function getHasOrderByPrimaryKey($needed = true)
    {
        return $this->hasOrderByPrimaryKey;
    }

    public function search()
    {

    }
}
