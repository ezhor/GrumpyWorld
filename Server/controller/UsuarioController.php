<?php

/**
 * Created by PhpStorm.
 * User: dparrado
 * Date: 24/01/18
 * Time: 9:47
 */

require_once "Controller.php";
require_once __DIR__."/../Authenticacion.php";

class UsuarioController extends Controller{
    public function managePostVerb(Request $request){

        if (isset($request->getUrlElements()[2])) {
            $response = new Response('405', null, null, $request->getAccept());
            $response->generate();
        }else{
            if(isset($request->getBodyParameters()['usuario']) && isset($request->getBodyParameters()['contrasena'])){
                $authentication = new Authentication(null, $request->getBodyParameters()['usuario'], $request->getBodyParameters()['contrasena'], null);
                $conseguido = UsuarioHandlerModel::insertarUsuario($authentication);
                if($conseguido){
                    $response = new Response('200', null, null, $request->getAccept(), $request->getAuthentication()->getId());

                }else{
                    $response = new Response('409', null, null, $request->getAccept(), null);
                }
            }else{
                $response = new Response('400', null, null, $request->getAccept(), null);
            }

            $response->generate();
        }
    }
}