package tech.pylons.easel.ui.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import tech.pylons.easel.R
import tech.pylons.easel.R.*

class HomeFragment : Fragment() {
    lateinit var text : TextView

    override fun onCreateView(
            inflater: LayoutInflater,
            container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(layout.fragment_home, container, false)
    }

    override fun onStart() {
        super.onStart()
        text = requireActivity().window.findViewById(R.id.page_title)
        text.visibility = View.INVISIBLE
    }

    override fun onStop() {
        super.onStop()
        text.visibility = View.VISIBLE
    }
}