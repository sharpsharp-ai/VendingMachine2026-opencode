package de.sharpsharp.gildedrose;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

import org.junit.Test;

public class AgedBrieTest {

    @Test
    public void agedBrieGainsOneQualityBeforeTheSellDate() {
        Item item = new Item("Aged Brie", 1, 49);

        GildedRose.with(item).updateQuality();

        assertThat(item.getQuality(), is(50));
        assertThat(item.getSellIn(), is(0));
    }

    @Test
    public void agedBrieGainsTwoQualityAfterTheSellDate() {
        Item item = new Item("Aged Brie", 0, 48);

        GildedRose.with(item).updateQuality();

        assertThat(item.getQuality(), is(50));
        assertThat(item.getSellIn(), is(-1));
    }

    @Test
    public void agedBrieAtMaxQualityStaysAtMaxQuality() {
        Item item = new Item("Aged Brie", 0, 50);

        GildedRose.with(item).updateQuality();

        assertThat(item.getQuality(), is(50));
        assertThat(item.getSellIn(), is(-1));
    }
}
