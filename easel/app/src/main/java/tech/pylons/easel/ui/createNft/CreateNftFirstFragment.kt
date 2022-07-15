package tech.pylons.easel.ui.createNft

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import tech.pylons.easel.R
import tech.pylons.easel.databinding.FragmentCreateNftFirstBinding

class CreateNftFirstFragment: Fragment() {
    lateinit var binding: FragmentCreateNftFirstBinding
    private val viewModel: CreateNftViewModel by viewModels(ownerProducer = {
        requireParentFragment()})

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_create_nft_first, container, false)
        binding.createViewModel = viewModel
        binding.lifecycleOwner = requireParentFragment()
        binding.buttonNext.isEnabled = false

        viewModel.mBtnNextMediator.observe(viewLifecycleOwner, { validationResult ->
            binding.buttonNext.isEnabled = validationResult
        })

        return binding.root
    }
}