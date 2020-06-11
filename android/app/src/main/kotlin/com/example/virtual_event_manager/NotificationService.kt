package com.example.virtual_event_manager

import android.app.*
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import androidx.annotation.Nullable
import androidx.core.app.NotificationCompat


class NotificationService: Service(){

    val player = MediaPlayer()
    var id = "98765432"

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        createNotificationChannel()
        val pm = this.packageManager
        val launchIntent = pm.getLaunchIntentForPackage("com.example.virtual_event_manager")
        val data = intent!!.extras
        id = data!!["Id"]!!.toString()
        data.putString("route","reminder")
        launchIntent!!.putExtras(data)
        launchIntent.setAction(Intent.ACTION_MAIN)
        launchIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
        launchIntent.addCategory(Intent.CATEGORY_LAUNCHER)
        val pintent = PendingIntent.getActivity(this,id.toInt(),launchIntent,0)
        val nbuilder = NotificationCompat.Builder(this,"com.example.virtual_event_manager.notification.channel")
                .setSmallIcon(R.mipmap.ic_stat_em_1)
                .setContentTitle("Reminder: " + data["Text"]!!.toString())
                .setContentText("Reminder Date and Time: " + data["Date"]!!.toString() + " " + data["Time"]!!.toString())
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setCategory(NotificationCompat.CATEGORY_ALARM)
                .setFullScreenIntent(pintent,true)
                .setAutoCancel(true)

        val dismissIntent = Intent(this,MyReceiver::class.java)
        dismissIntent.putExtras(data)
        dismissIntent.action = "com.example.virtual_event_manager.notification.channel.RESPONSE_DISMISS"
        dismissIntent.addCategory(Intent.CATEGORY_DEFAULT)
        val dismissPendingIntent = PendingIntent.getBroadcast(this,id.toInt(),dismissIntent,PendingIntent.FLAG_ONE_SHOT)
        nbuilder.addAction(android.R.drawable.ic_menu_close_clear_cancel,"Dismiss",dismissPendingIntent)

        val snoozeIntent = Intent(this,MyReceiver::class.java)
        snoozeIntent.putExtras(data)
        snoozeIntent.action = "com.example.virtual_event_manager.notification.channel.RESPONSE_SNOOZE"
        snoozeIntent.addCategory(Intent.CATEGORY_DEFAULT)
        val snoozePendingIntent = PendingIntent.getBroadcast(this,id.toInt(),snoozeIntent,PendingIntent.FLAG_ONE_SHOT)
        nbuilder.addAction(android.R.drawable.ic_lock_idle_alarm,"Snooze",snoozePendingIntent)

        if(data["Silent"]!!.toString() == "false"){
            val alarmRingtone: Uri = RingtoneManager.getActualDefaultRingtoneUri(this,RingtoneManager.TYPE_ALARM)
            val attributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()
            player.setDataSource(this,alarmRingtone)
            player.setAudioAttributes(attributes)
            player.isLooping = true
            player.prepare()
            player.start()
        }
        startForeground(id.toInt(),nbuilder.build())
        return START_NOT_STICKY
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = getString(R.string.channel_name)
            val descriptionText = getString(R.string.channel_description)
            val CHANNEL_ID = getString(R.string.CHANNEL_ID)
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            channel.enableVibration(true)
            val notificationManager: NotificationManager =
                    getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val att = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                    .build()
            val uri= RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            channel.setSound(uri,att)
            notificationManager.createNotificationChannel(channel)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if(player.isPlaying ){
            player.stop()
            player.release()
        }
        val stopIntent = Intent(this,MyReceiver::class.java)
        stopIntent.action = "com.example.virtual_event_manager.notification.channel.STOP"
        stopIntent.addCategory(Intent.CATEGORY_DEFAULT)
        val stopPendingIntent = PendingIntent.getBroadcast(this,id.toInt(),stopIntent,PendingIntent.FLAG_ONE_SHOT)
        val manager = this.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        manager.cancel(stopPendingIntent)

    }

    @Nullable
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}