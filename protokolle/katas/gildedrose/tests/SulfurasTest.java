package de.sharpsharp.gildedrose;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

import org.junit.Test;

public class SulfurasTest {

    @Test
    public void sulfurasKeepsItsQualityAndSellInAtMinusOne() {
        Item item = new Item("Sulfuras, Hand of Ragnaros", -1, 80);

        GildedRose.with(item).updateQuality();

        assertThat(item.getQuality(), is(80));
        assertThat(item.getSellIn(), is(-1));
    }
}
