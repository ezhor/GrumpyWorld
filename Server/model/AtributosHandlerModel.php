<?php

/**
 * Created by PhpStorm.
 * User: dparrado
 * Date: 31/01/18
 * Time: 9:02
 */

require_once "RolloModel.php";

class AtributosHandlerModel
{
    public static function getAtributos($id){
        $db = DatabaseModel::getInstance();
        $db_connection = $db->getConnection();

        $query = "SELECT Fuerza, Constitucion, Destreza, FinEntrenamiento
                    FROM  Rollos AS R
                      INNER JOIN Atributos AS A
                      ON A.ID = R.ID_Atributos
                    WHERE R.ID_Usuario = ?;";

        $prep_query = $db_connection->prepare($query);
        $prep_query->bind_param('i', $id);
        $prep_query->bind_result($fuerza, $constitucion, $destreza, $finEntrenamiento);
        $prep_query->execute();
        $prep_query->fetch();

        $atributos = new AtributosModel($fuerza, $constitucion, $destreza, $finEntrenamiento);

        return $atributos;
    }

    public static function entrenar($id, $atributo){
        $conseguido = false;

        $db = DatabaseModel::getInstance();
        $db_connection = $db->getConnection();

        //Se comprueba si ha pasado tiempo suficiente para volver a entrenar
        $query ='SELECT FinEntrenamiento FROM Atributos
                                              INNER JOIN Rollos ON Atributos.ID = Rollos.ID_Atributos
                                              WHERE Rollos.ID_Usuario = ?;';
        $prep_query = $db_connection->prepare($query);
        $prep_query->bind_param('i', $id);
        $prep_query->bind_result($finEntrenamiento);
        $prep_query->execute();
        $prep_query->fetch();

        //Si ha pasado tiempo suficiente, se entrena
        if($finEntrenamiento<=time()){
            $prep_query->free_result();
            $query = "CALL entrenar(?,?);";
            $prep_query = $db_connection->prepare($query);
            $prep_query->bind_param('is', $id, $atributo);

            $prep_query->execute();
            if($db_connection->affected_rows>0){
                $conseguido = true;
            }
        }
        return $conseguido;
    }
}