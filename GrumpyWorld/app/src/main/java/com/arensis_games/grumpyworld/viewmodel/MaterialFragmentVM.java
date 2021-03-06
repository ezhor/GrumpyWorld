package com.arensis_games.grumpyworld.viewmodel;

import android.app.Application;
import android.arch.lifecycle.AndroidViewModel;
import android.arch.lifecycle.MutableLiveData;
import android.support.annotation.NonNull;

import com.arensis_games.grumpyworld.R;
import com.arensis_games.grumpyworld.connection.BearerAuthInterceptor;
import com.arensis_games.grumpyworld.connection.FabricacionInterface;
import com.arensis_games.grumpyworld.connection.GestoraToken;
import com.arensis_games.grumpyworld.model.Supermaterial;

import okhttp3.OkHttpClient;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by dparrado on 15/02/18.
 */

public class MaterialFragmentVM extends AndroidViewModel {
    private MutableLiveData<Supermaterial> ldSupermaterial;
    private MutableLiveData<String> ldError;

    public MaterialFragmentVM(@NonNull Application application) {
        super(application);
        ldSupermaterial = new MutableLiveData<>();
        ldError = new MutableLiveData<>();
    }

    public MutableLiveData<Supermaterial> getLdSupermaterial() {
        return ldSupermaterial;
    }

    public MutableLiveData<String> getLdError() {
        return ldError;
    }

    public void obtenerSupermaterial(int id){
        OkHttpClient client;
        Retrofit retrofit;
        FabricacionInterface fabricacionInterface;

        /*
            Android puede haber borrado el dato estático si necesita memoria.
            En ese caso se manda al usuario a la pantalla de inicio para que
            el sistema inicie sesión de nuevo.
        */
        if(GestoraToken.getAuthorization() != null){
            client = new OkHttpClient.Builder()
                    .addInterceptor(new BearerAuthInterceptor(GestoraToken.getAuthorization()))
                    .build();

            retrofit = new Retrofit.Builder()
                    .baseUrl(getApplication().getString(R.string.SERVER_URL))
                    .client(client)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();

            fabricacionInterface = retrofit.create(FabricacionInterface.class);

            fabricacionInterface.getSupermaterial(id).enqueue(new Callback<Supermaterial>() {
                @Override
                public void onResponse(Call<Supermaterial> call, Response<Supermaterial> response) {
                    if(response.isSuccessful()){
                        ldSupermaterial.postValue(response.body());
                        GestoraToken.setAuthorization(response.headers().get("Authorization"));
                    }else{
                        /*
                            Puede haber pasado una hora desde que el usuario uso la app por última
                            vez y que Android aún no haya borrado el token de memoria por lo que
                            dejaría de ser válido (401 Unauthorized)
                            En ese caso se manda al usuario a la pantalla de inicio para que
                            el sistema inicie sesión de nuevo.
                         */
                        ldError.setValue(String.valueOf(response.code()));
                    }
                }

                @Override
                public void onFailure(Call<Supermaterial> call, Throwable t) {
                    ldError.postValue(t.getMessage());
                }
            });
        }else{
            ldError.setValue("401");
        }
    }

    public void fabricar(int id) {
        OkHttpClient client;
        Retrofit retrofit;
        FabricacionInterface fabricacionInterface;

        if(GestoraToken.getAuthorization() != null){
            client = new OkHttpClient.Builder()
                    .addInterceptor(new BearerAuthInterceptor(GestoraToken.getAuthorization()))
                    .build();

            retrofit = new Retrofit.Builder()
                    .baseUrl(getApplication().getString(R.string.SERVER_URL))
                    .client(client)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();

            fabricacionInterface = retrofit.create(FabricacionInterface.class);

            fabricacionInterface.fabricarSupermaterial(id).enqueue(new Callback<Supermaterial>() {
                @Override
                public void onResponse(Call<Supermaterial> call, Response<Supermaterial> response) {
                    if(response.isSuccessful()){
                        ldSupermaterial.postValue(response.body());
                        GestoraToken.setAuthorization(response.headers().get("Authorization"));
                    }else{
                        ldError.setValue(String.valueOf(response.code()));
                    }
                }

                @Override
                public void onFailure(Call<Supermaterial> call, Throwable t) {
                    ldError.postValue(t.getMessage());
                }
            });
        }else{
            ldError.setValue("401");
        }
    }
}
