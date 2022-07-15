package tech.pylons.easel.ui.dashboard

import android.content.Intent
import android.os.Bundle
import android.text.Spannable
import android.text.SpannableString
import android.text.style.ImageSpan
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.GridView
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import tech.pylons.droidwallet.WalletHandler
import tech.pylons.easel.R
import tech.pylons.easel.databinding.BottomSheetDialogBinding
import tech.pylons.lib.types.tx.recipe.*


class DashboardFragment : Fragment() {

    private val viewModel: DashboardViewModel by viewModels()
    private lateinit var itemList: MutableList<Recipe>
    private var adapter: ImageListAdapter? = null

    private lateinit var gridview: GridView

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_dashboard, container, false)
        gridview = root.findViewById(R.id.gridview)
        itemList = viewModel.createdNfts.value!!
        adapter = ImageListAdapter(requireContext(), R.layout.list_item, itemList)
        gridview.adapter = adapter

        gridview.onItemClickListener = AdapterView.OnItemClickListener { _, _, position, _ ->
            val view: BottomSheetDialogBinding = DataBindingUtil.inflate(
                inflater, R.layout.bottom_sheet_dialog, container, false
            )

            val item = itemList[position]
            val coin_denom = item.coinInputs[0].coin
            val coin_count = item.coinInputs[0].count
            val item_id = item.id

            val url = item.entries.itemOutputs[0].strings.find {
                it.key == "NFT_URL"
            }?.value.orEmpty()
            val item_name = item.entries.itemOutputs[0].strings.find {
                it.key == "Name"
            }?.value.orEmpty()
            val item_desc = item.entries.itemOutputs[0].strings.find {
                it.key == "Description"
            }?.value.orEmpty()

            val price: Spannable =
                SpannableString("  ${SpannableString(coin_count.toString())} pylons")
            price.setSpan(
                ImageSpan(requireContext(), R.drawable.ic_cosmos_atoms_white_25x25),
                0,
                1,
                Spannable.SPAN_EXCLUSIVE_INCLUSIVE
            )

            view.dialogTitle.text = item_name//"Winter Landscape"
            view.dialogText1.text =
                item_desc //"Oil on canvas. It will be burned on video upon sale."
            when (coin_denom) {
                "USD" -> {
                    view.dialogText2.text = "${"%.2f".format(coin_count.toDouble() / 100)} USD"
                }
                else -> {
                    view.dialogText2.text = "$coin_count pylon"//"20"
                }
            }


            view.btnCopyWeblink.setOnClickListener {
                val sendIntent: Intent = Intent().apply {
                    action = Intent.ACTION_SEND
                    putExtra(
                        Intent.EXTRA_TEXT,
                        WalletHandler.getWebLink(item_name, item_id)
                    )
                    type = "text/plain"
                }

                val shareIntent = Intent.createChooser(sendIntent, null)
                startActivity(shareIntent)
            }

            val dialog = BottomSheetDialog(requireContext())
            dialog.setContentView(view.root)
            dialog.show()
        }
        return root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel.createdNfts.observe(viewLifecycleOwner) { nftsList ->
            itemList = nftsList
            adapter?.notifyDataSetChanged()
            gridview.invalidateViews()
        }
    }

    override fun onResume() {
        super.onResume()

        CoroutineScope(Dispatchers.IO).launch {
            WalletHandler.listNfts(requireContext()) {
                CoroutineScope(Dispatchers.Main).launch {

                    adapter?.notifyDataSetChanged()

                }

            }
        }
    }
}