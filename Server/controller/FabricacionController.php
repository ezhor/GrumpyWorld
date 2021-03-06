<?php

/**
 * Created by PhpStorm.
 * User: dparrado
 * Date: 31/01/18
 * Time: 9:49
 */

require_once "Controller.php";

class FabricacionController extends Controller
{
    public function manageGetVerb(Request $request){
        $idRollo = $request->getAuthentication()->getId();

        if (isset($request->getUrlElements()[2])) {
            $idEquipable = $request->getUrlElements()[2];
            if(is_numeric($idEquipable)){
                if(FabricacionHandlerModel::puedeFabricar($idRollo, $idEquipable)){
                    $equipableDetalle = FabricacionHandlerModel::getEquipableDetalle($idRollo, $idEquipable);
                    $response = new Response(200, null, $equipableDetalle, $request->getAccept(), $idRollo);
                }else{
                    $response = new Response(403, null, null, $request->getAccept(), $idRollo);
                }
            }else{
                $response = new Response(404, null, null, $request->getAccept(), $idRollo);
            }

        }else{
            $equipables = FabricacionHandlerModel::getEquipablesDisponibles($idRollo);
            $response = new Response(200, null, $equipables, $request->getAccept(), $idRollo);
        }
        $response->generate();
    }

    public function managePostVerb(Request $request){
        if (isset($request->getUrlElements()[2])) {
            $idRollo = $request->getAuthentication()->getId();
            $idEquipable = $request->getUrlElements()[2];
            $conseguido = FabricacionHandlerModel::fabricar($idRollo, $idEquipable);
            $equipableDetalle = FabricacionHandlerModel::getEquipableDetalle($idRollo, $idEquipable);
            if($conseguido){
                $response = new Response(200, null, $equipableDetalle, $request->getAccept(), $idRollo);
            }else{
                $response = new Response(403, null, null, $request->getAccept(), $idRollo);
            }
        }else{
            $response = new Response(404, null, null, $request->getAccept());

        }
        $response->generate();
    }
}