<?php

namespace App;

class SendCode
{
    protected $mailer;
    protected $member;
    public function __construct()
    {
        $this->mailer = new Mailer();
        $m = new Member();
        $this->member = $m->current();
    }

    public function sendCodeToggle2fa($to)
    {
        return $this->mailer->toggle2fa($to);
    }
}
