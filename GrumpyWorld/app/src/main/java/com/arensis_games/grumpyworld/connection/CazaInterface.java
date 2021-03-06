package com.arensis_games.grumpyworld.connection;

import com.arensis_games.grumpyworld.model.Caza;
import com.arensis_games.grumpyworld.model.EstadoCaza;
import com.arensis_games.grumpyworld.model.Turno;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.POST;

/**
 * Created by dparrado on 15/02/18.
 */

public interface CazaInterface {
    @GET("/caza")
    Call<Caza> getCaza();

    @POST("/caza")
    @Headers("Content-Type: application/json")
    Call<EstadoCaza> postTurno(@Body Turno turno);
}
