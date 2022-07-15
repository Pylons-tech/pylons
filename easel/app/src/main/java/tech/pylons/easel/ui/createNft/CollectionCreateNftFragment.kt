package tech.pylons.easel.ui.createNft

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.viewpager2.adapter.FragmentStateAdapter
import androidx.viewpager2.widget.ViewPager2
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import tech.pylons.easel.R

class CollectionCreateNftFragment : Fragment(){

    private lateinit var createNftCollectionAdapter: CreateNftCollectionAdapter
    private lateinit var viewPager: ViewPager2

    private val viewModel: CreateNftViewModel by viewModels(ownerProducer = {this})

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_collection_create_nft, container, false)
        return root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        createNftCollectionAdapter = CreateNftCollectionAdapter(this)
        viewPager = view.findViewById(R.id.pager)
        viewPager.adapter = createNftCollectionAdapter
        viewPager.isUserInputEnabled = false

        val tabLayout: TabLayout = view.findViewById(R.id.tab_layout)
        TabLayoutMediator(tabLayout, viewPager) { tab, position ->
        }.attach()

        viewModel.item.observe(viewLifecycleOwner, {
            viewPager.currentItem = it
        })

        viewModel.swipeEnabled.observe(viewLifecycleOwner, {
            viewPager.isUserInputEnabled = it
        })
    }
}

class CreateNftCollectionAdapter(fragment: Fragment) : FragmentStateAdapter(fragment) {

    override fun getItemCount(): Int = 3

    override fun createFragment(position: Int): Fragment {
        return when (position) {
            0 -> CreateNftLocationFragment()
            1 -> CreateNftFirstFragment()
            2 -> CreateNftSecondFragment()
            else -> CreateNftLocationFragment()
        }
    }
}
