package de.sharpsharp.gildedrose;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

import org.junit.Test;

public class BackstagePassTest {

    @Test
    public void backstagePassGainsOneQualityWhenThereAreElevenDaysLeft() {
        Item item = new Item("Backstage passes to a TAFKAL80ETC concert", 11, 48);

        GildedRose.with(item).updateQuality();

        assertThat(item.getQuality(), is(49));
        assertThat(item.getSellIn(), is(10));
    }

    @Test
    public void backstagePassGainsTwoQualityWhenThereAreTenDaysLeft() {
        Item item = new Item("Backstage passes to a TAFKAL80ETC concert", 10, 48);

        GildedRose.with(item).updateQuality();

        assertThat(item.getQuality(), is(50));
        assertThat(item.getSellIn(), is(9));
    }

    @Test
    public void backstagePassAtSixDaysLeftDoesNotGetTheSecondBonus() {
        Item item = new Item("Backstage passes to a TAFKAL80ETC concert", 6, 48);

        GildedRose.with(item).updateQuality();

        assertThat(item.getQuality(), is(50));
        assertThat(item.getSellIn(), is(5));
    }

    @Test
    public void backstagePassGetsThreeQualityWhenThereAreFiveDaysLeft() {
        Item item = new Item("Backstage passes to a TAFKAL80ETC concert", 5, 47);

        GildedRose.with(item).updateQuality();

        assertThat(item.getQuality(), is(50));
        assertThat(item.getSellIn(), is(4));
    }

    @Test
    public void backstagePassAtMaxQualityDoesNotIncreaseFurther() {
        Item item = new Item("Backstage passes to a TAFKAL80ETC concert", 5, 49);

        GildedRose.with(item).updateQuality();

        assertThat(item.getQuality(), is(50));
        assertThat(item.getSellIn(), is(4));
    }

    @Test
    public void backstagePassDropsToZeroAfterTheConcert() {
        Item item = new Item("Backstage passes to a TAFKAL80ETC concert", 0, 50);

        GildedRose.with(item).updateQuality();

        assertThat(item.getQuality(), is(0));
        assertThat(item.getSellIn(), is(-1));
    }
}
