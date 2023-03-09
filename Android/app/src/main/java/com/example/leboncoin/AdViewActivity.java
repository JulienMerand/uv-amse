package com.example.leboncoin;

import android.content.Intent;
import android.os.Bundle;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

public class AdViewActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_ad);

        Intent i = getIntent();
        AdModel Model = (AdModel) i.getSerializableExtra("model");
        // Image
        ImageView img = (ImageView) findViewById(R.id.view_image);
        img.setImageResource(Model.getImage());
        // Title
        TextView titre = (TextView) findViewById(R.id.view_txt_titre);
        titre.setText(Model.getTitle());
        // Address
        TextView address = (TextView) findViewById(R.id.view_txt_address);
        address.setText(Model.getAddress());


    }
}
