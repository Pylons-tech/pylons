package tech.pylons.easel.ui.createNft

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.findNavController
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import tech.pylons.droidwallet.WalletHandler
import tech.pylons.easel.R
import tech.pylons.easel.databinding.BottomSheetDialogBinding
import tech.pylons.easel.databinding.FragmentCreateNftSecondBinding
import tech.pylons.easel.ui.UI
import android.graphics.BitmapFactory

import android.graphics.Bitmap
import java.io.IOException
import java.net.URL


class CreateNftSecondFragment : Fragment() {
    private lateinit var binding: FragmentCreateNftSecondBinding
    private val viewModel: CreateNftViewModel by viewModels(ownerProducer = {
        requireParentFragment()
    })

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding =
            DataBindingUtil.inflate(inflater, R.layout.fragment_create_nft_second, container, false)
        binding.createViewModel = viewModel
        binding.lifecycleOwner = requireParentFragment()
        binding.buttonCreateNft.isEnabled = false

        viewModel.mBtnCreateMediator.observe(viewLifecycleOwner, { validationResult ->
            binding.buttonCreateNft.isEnabled = validationResult
        })

        viewModel.CreateNftResult.value = false

        viewModel.CreateNftResult.observe(viewLifecycleOwner, { createNftResult ->
            when (createNftResult) {
                true -> {
                    findNavController().navigate(R.id.action_CreateNft_to_DashboardFragment)
                }
                false -> {
                    binding.buttonCreateNft.isEnabled = true
                    binding.buttonCreateNft.text = getString(R.string.title_create)
                }
            }
        })

        binding.iconRoyaltyInfo.setOnClickListener {
            val view: BottomSheetDialogBinding = DataBindingUtil.inflate(
                inflater, R.layout.bottom_sheet_dialog, container, false
            )
            view.dialogTitle.text = getString(R.string.nft_royalty_info_title)
            view.dialogText1.text = getString(R.string.nft_royalty_info_text)
            view.dialogText2.text = getString(R.string.nft_royalty_info_guide)
            val dialog = BottomSheetDialog(requireContext())
            dialog.setContentView(view.root)
            dialog.show()
        }


        binding.buttonCreateNft.apply {
            setOnClickListener {

                //Toast.makeText(context, R.string.info_check_your_notifications, Toast.LENGTH_LONG)
                //    .show()

                val loading = UI.displayLoading(requireContext(), "Check your notifications.\nCreating Nft ...")

                isEnabled = false
                text = getString(R.string.loading)

                CoroutineScope(Dispatchers.IO).launch {
                    var imageWidth = viewModel.imageWidth.value
                    var imageHeight = viewModel.imageHeight.value
                    if(imageWidth == null){
                        try {
                            val url = URL(viewModel.nftUrl.value.toString())
                            val bmp: Bitmap = BitmapFactory.decodeStream(url.openConnection().getInputStream())
                            if(bmp != null) {
                                imageWidth = bmp.width
                                imageHeight = bmp.height
                            }
                        }
                        catch (e: IOException){

                        }
                    }
                    WalletHandler.createNft(
                        requireContext(),
                        viewModel.nftName.value.toString(),
                        viewModel.nftPrice.value.toString(),
                        resources.getStringArray(R.array.currency_array)
                            .get(viewModel.nftCurrency.value!!),
                        viewModel.nftRoyalty.value.toString(),
                        viewModel.nftQty.value!!.toLong(),
                        viewModel.nftUrl.value.toString(),
                        viewModel.nftDescription.value.toString(),
                        imageWidth!!.toLong(),
                        imageHeight!!.toLong()
                    ) {
                        loading.dismiss()
                        viewModel.CreateNftResult.postValue(it)
                    }
                }
            }
        }

        return binding.root
    }
}