<?php


namespace App;

use Illuminate\Support\Facades\Log;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;


class Mailer
{
    protected $mail;
    public function __construct()
    {
        $this->mail = new PHPMailer(true);
        //Server settings
        //$this->mail->SMTPDebug = SMTP::DEBUG_SERVER;                      //Enable verbose debug output
        $this->mail->isSMTP();                                            //Send using SMTP
        $this->mail->Host       = 'smtp.gmail.com';                     //Set the SMTP server to send through
        $this->mail->SMTPAuth   = true;                                   //Enable SMTP authentication
        $this->mail->Username   = env('GOOGLE_EMAIL_ADDRESS', 'seven.gogun@gmail.com');                     //SMTP username
        $this->mail->Password   = env('GOOGLE_EMAIL_PASSWORD', 'a&NVx6UhT`8y-8Nr');                               //SMTP password
        $this->mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;            //Enable implicit TLS encryption
        $this->mail->Port       = 465; //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`
        $this->mail->CharSet = 'UTF-8';

        //Recipients
        $this->mail->setFrom('seven.gogun@gmail.com', 'GoGun Service');
                       //Name is optional
        //$mail->addReplyTo('info@example.com', 'Information');
        //$mail->addCC('cc@example.com');
        //$mail->addBCC('bcc@example.com');

        //Attachments
        //$mail->addAttachment('/var/tmp/file.tar.gz');         //Add attachments
        //$mail->addAttachment('/tmp/image.jpg', 'new.jpg');    //Optional name

        //Content

    }

    public function TwoFactorAuthentication($to)
    {
        $code = uniqid();
        $code = strtoupper($code);
        try {
            $this->mail->isHTML(true);                                  //Set email format to HTML
            $this->mail->Subject = 'Xác thực 2 lớp - GoGun';
            $this->mail->Body = '<p>Hãy nhập mã dưới đây để xác thực tài khoản của bạn:</p><h3>'.$code.'</h3>';
            $this->mail->addAddress($to);     //Add a recipient
            //$mail->addAddress('seven.gogun@gmail.com');
            $this->mail->send();
            return ['success' => true, 'code' => $code];
        } catch (Exception $e) {
            Log::channel('email')->debug($this->mail->ErrorInfo);
            return ['success' => false, 'message' => ''];
        }
    }

    public function ForgotPass($to)
    {
        $code = uniqid();
        $code = strtoupper($code);
        try {
            $this->mail->isHTML(true);                                  //Set email format to HTML
            $this->mail->Subject = 'Khôi phục mật khẩu - Go-Gun';
            $this->mail->Body = '<p>Hãy nhập mã dưới đây để khôi phục mật khẩu cho tài khoản của bạn:</p><h3>'.$code.'</h3>';
            $this->mail->addAddress($to);     //Add a recipient
            //$mail->addAddress('seven.gogun@gmail.com');
            $this->mail->send();
            return ['success' => true, 'code' => $code];
        } catch (Exception $e) {
            Log::channel('email')->debug($this->mail->ErrorInfo);
            return ['success' => false, 'message' => ''];
        }
    }

    public function toggle2fa($to)
    {
        $code = uniqid();
        $code = strtoupper($code);
        try {
            $this->mail->isHTML(true);
            $this->mail->Subject = 'Thiết lập xác thực 2 lớp - Go-Gun';
            $this->mail->Body = '<p>Hãy nhập mã dưới đây để hoàn tất thiết lập xác thực 2 lớp cho tài khoản của bạn:</p><h3>'.$code.'</h3>';
            $this->mail->addAddress($to);
            $this->mail->send();
            return ['success' => true, 'code' => $code];
        } catch (Exception $e) {
            Log::channel('email')->debug($this->mail->ErrorInfo);
            return ['success' => false, 'message' => ''];
        }
    }

    public function verifyEmail($to)
    {
        $code = uniqid();
        $code = strtoupper($code);
        try {
            $this->mail->isHTML(true);
            $this->mail->Subject = 'Xác thực Email - Go-Gun';
            $this->mail->Body = '<p>Hãy nhập mã dưới đây để xác thực email của bạn:</p><h3>'.$code.'</h3>';
            $this->mail->addAddress($to);
            $this->mail->send();
            return ['success' => true, 'code' => $code];
        } catch (Exception $e) {
            Log::channel('email')->debug($this->mail->ErrorInfo);
            return ['success' => false, 'message' => ''];
        }
    }
}
