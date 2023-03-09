package com.example.leboncoin;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;

public class AdAddActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_ad);

        ImageView img = (ImageView) findViewById(R.id.input_image);
        img.setImageResource(R.drawable.image_add);

        TextInputLayout inputlayout1 = (TextInputLayout) findViewById(R.id.TextInputLayout1);
        TextInputLayout inputlayout2 = (TextInputLayout) findViewById(R.id.TextInputLayout2);


        Button btn_save = (Button) findViewById(R.id.btn_save);
        btn_save.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                String titre = inputlayout1.getEditText().getText().toString();
                String address = inputlayout2.getEditText().getText().toString();
                if(titre!=null & address!=null){
                    AdModel model = new AdModel(titre, address, R.drawable.image_add);
                    Intent goListViewActivity = new Intent(AdAddActivity.this, MainActivity.class);
                    goListViewActivity.putExtra("add_model", model);
                    startActivity(goListViewActivity);
                }
            }
        });

    }
}
