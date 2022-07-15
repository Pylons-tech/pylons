package tech.pylons.easel.ui.dashboard

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.ImageView
import tech.pylons.lib.types.tx.recipe.Recipe
import com.squareup.picasso.Picasso
import tech.pylons.easel.R


internal class ImageListAdapter internal constructor(
        context: Context,
        private val resource: Int,
        private val itemList: MutableList<Recipe>
) : ArrayAdapter<ImageListAdapter.ItemHolder>(context, resource) {

    override fun getCount(): Int {
        return this.itemList.size
    }

    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        var convertView = convertView

        val holder: ItemHolder
        if (convertView == null) {
            convertView = LayoutInflater.from(parent.context).inflate(resource, null)
            holder = ItemHolder()
            holder.icon = convertView.findViewById(R.id.nft_image)
            convertView.tag = holder
        } else {
            holder = convertView.tag as ItemHolder
        }

        val item = itemList.get(position)
        val coin_denom = item.coinInputs.get(0).coin
        val coin_count = item.coinInputs.get(0).count
        val url = item.entries.itemOutputs.get(0).strings.find{
            it.key == "NFT_URL"
        }?.value

        Picasso.get().isLoggingEnabled = true

        Picasso.get()
                .load(url)//"https://www.imagesource.com/wp-content/uploads/2019/06/Rio.jpg")
                .placeholder(R.drawable.ic_add_box)
                .error(R.drawable.ic_add_box)
                //.resize(139, 139)
                .into(holder.icon)

        return convertView!!
    }

    internal class ItemHolder {
        var icon: ImageView? = null
    }
}