package com.karasustudio.admobandroid

import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.interstitial.InterstitialAd
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback
import com.google.android.gms.ads.rewarded.RewardedAd
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback
import com.google.android.gms.ads.rewardedinterstitial.RewardedInterstitialAd
import com.google.android.gms.ads.rewardedinterstitial.RewardedInterstitialAdLoadCallback
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot

class AdmobAndroid(godot: Godot?) : GodotPlugin(godot) {
    override fun getPluginName(): String = "AdmobAndroid"

    private val onInitializedSignalName = "on_initialized";
    private val onLoadedAdSignalName = "on_loaded_ad";
    private val onShowedAdSignalName = "on_showed_ad";
    private val onGrantedRewardSignalName = "on_granted_reward";
    private val onDismissedAdSignalName = "on_dismissed_ad"
    private val onAdClickedSignalName = "on_ad_clicked"
    private val onAdImpressionSignalName = "on_ad_impression"

    private val succeed = "succeed"
    private val failed = "failed"

    private val preloadedAds = mutableMapOf<String, Any?>();

    @UsedByGodot
    fun initialize() {
        activity?.run {
            MobileAds.initialize(this) {
                emitSignal(onInitializedSignalName, succeed)
            }
        }
    }

    @UsedByGodot
    fun loadInterstitial(adUnit: String, identifier: String) {
        runOnUiThread {
            activity?.run {
                val adRequest = AdRequest.Builder().build()

                InterstitialAd.load(this, adUnit, adRequest, object : InterstitialAdLoadCallback() {
                    override fun onAdFailedToLoad(error: LoadAdError) {
                        super.onAdFailedToLoad(error)
                        emitSignal(onLoadedAdSignalName, failed, identifier)
                    }

                    override fun onAdLoaded(interstitial: InterstitialAd) {
                        super.onAdLoaded(interstitial)
                        preloadedAds[identifier] = interstitial
                        emitSignal(onLoadedAdSignalName, succeed, identifier)
                    }
                })
            }
        }
    }

    @UsedByGodot
    fun showInterstitial(hashIdentifier: String) {
        runOnUiThread {
            activity?.run {
                val interstitial = preloadedAds[hashIdentifier]

                interstitial?.let {
                    (it as InterstitialAd).fullScreenContentCallback = object : FullScreenContentCallback() {
                        override fun onAdClicked() {
                            emitSignal(onAdClickedSignalName, succeed, hashIdentifier)
                        }

                        override fun onAdDismissedFullScreenContent() {
                            emitSignal(onDismissedAdSignalName, succeed, hashIdentifier)
                            preloadedAds.remove(hashIdentifier)
                        }

                        override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                            emitSignal(onShowedAdSignalName, failed, hashIdentifier)
                        }

                        override fun onAdImpression() {
                            emitSignal(onAdImpressionSignalName, succeed, hashIdentifier)
                        }

                        override fun onAdShowedFullScreenContent() {
                            emitSignal(onShowedAdSignalName, succeed, hashIdentifier)
                        }
                    }

                    it.show(this)
                }
            }
        }
    }

    @UsedByGodot
    fun loadRewarded(adUnit: String, identifier: String) {
        runOnUiThread {
            activity?.run {
                val adRequest = AdRequest.Builder().build()
                RewardedAd.load(this, adUnit, adRequest, object : RewardedAdLoadCallback() {
                    override fun onAdFailedToLoad(adError: LoadAdError) {
                        super.onAdFailedToLoad(adError)
                        emitSignal(onLoadedAdSignalName, failed, identifier)
                    }

                    override fun onAdLoaded(ad: RewardedAd) {
                        preloadedAds[identifier] = ad
                        emitSignal(onLoadedAdSignalName, succeed, identifier)
                    }
                })
            }
        }
    }

    @UsedByGodot
    fun showRewarded(hashIdentifier: String) {
        runOnUiThread {
            activity?.run {
                val rewarded = preloadedAds[hashIdentifier]

                rewarded?.let {
                    (it as RewardedAd).fullScreenContentCallback = object : FullScreenContentCallback() {
                        override fun onAdClicked() {
                            emitSignal(onAdClickedSignalName, succeed, hashIdentifier)
                        }

                        override fun onAdDismissedFullScreenContent() {
                            emitSignal(onDismissedAdSignalName, succeed, hashIdentifier)
                            preloadedAds.remove(hashIdentifier)
                        }

                        override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                            emitSignal(onShowedAdSignalName, failed, hashIdentifier)
                        }

                        override fun onAdImpression() {
                            emitSignal(onAdImpressionSignalName, succeed, hashIdentifier)
                        }

                        override fun onAdShowedFullScreenContent() {
                            emitSignal(onShowedAdSignalName, succeed, hashIdentifier)
                        }
                    }

                    it.show(this) {
                        emitSignal(
                            onGrantedRewardSignalName,
                            succeed,
                            hashIdentifier,
                            "type=${it.type}&amount=${it.amount}"
                        )
                    }
                }
            }
        }
    }

    @UsedByGodot
    fun loadRewardedInterstitial(adUnit: String, identifier: String) {
        runOnUiThread {
            activity?.run {
                RewardedInterstitialAd.load(this, adUnit,
                    AdRequest.Builder().build(), object : RewardedInterstitialAdLoadCallback() {
                        override fun onAdFailedToLoad(adError: LoadAdError) {
                            super.onAdFailedToLoad(adError)
                            emitSignal(onLoadedAdSignalName, failed, identifier)
                        }

                        override fun onAdLoaded(ad: RewardedInterstitialAd) {
                            preloadedAds[identifier] = ad
                            emitSignal(onLoadedAdSignalName, succeed, identifier)
                        }
                    })
            }
        }
    }

    @UsedByGodot
    fun showRewardedInterstitial(hashIdentifier: String) {
        runOnUiThread {
            activity?.run {
                val rewardedInterstitial = preloadedAds[hashIdentifier]

                rewardedInterstitial?.let {
                    (it as RewardedInterstitialAd).fullScreenContentCallback = object : FullScreenContentCallback() {
                        override fun onAdClicked() {
                            emitSignal(onAdClickedSignalName, succeed, hashIdentifier)
                        }

                        override fun onAdDismissedFullScreenContent() {
                            emitSignal(onDismissedAdSignalName, succeed, hashIdentifier)
                            preloadedAds.remove(hashIdentifier)
                        }

                        override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                            emitSignal(onShowedAdSignalName, failed, hashIdentifier)
                        }

                        override fun onAdImpression() {
                            emitSignal(onAdImpressionSignalName, succeed, hashIdentifier)
                        }

                        override fun onAdShowedFullScreenContent() {
                            emitSignal(onShowedAdSignalName, succeed, hashIdentifier)
                        }
                    }

                    it.show(this) {
                        emitSignal(
                            onGrantedRewardSignalName,
                            succeed,
                            hashIdentifier,
                            "type=${it.type}&amount=${it.amount}"
                        )
                    }
                }
            }
        }
    }

    override fun getPluginSignals(): MutableSet<SignalInfo> = mutableSetOf(
        SignalInfo(onInitializedSignalName, String::class.java),
        SignalInfo(onLoadedAdSignalName, String::class.java, String::class.java),
        SignalInfo(onShowedAdSignalName, String::class.java, String::class.java),
        SignalInfo(onGrantedRewardSignalName, String::class.java, String::class.java, String::class.java),
        SignalInfo(onDismissedAdSignalName, String::class.java, String::class.java),
        SignalInfo(onAdClickedSignalName, String::class.java, String::class.java),
        SignalInfo(onAdImpressionSignalName, String::class.java, String::class.java),
    )
}